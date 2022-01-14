# Place this file into your jekyll site _plugins directory, it will auto used by jekyll command.
require "open-uri"
module RailsProjectStats
    
    class SyncGenerator < Jekyll::Generator

      # repo: Hash
      # {"url": "https://github.com/rails/rails", "id": 12345 }
      def fetch_repo_data(repo)
        raise "Missing repo url, #{repo.inspect}" if repo["url"].to_s.empty?

        need_sync_repo = false
        repo_json_data = nil
        repo_id = repo["id"].to_i
        if repo_id > 0
          cache_repo_json_file = File.expand_path("../../_data/repos/#{repo_id}.json", __FILE__)
          if File.exist?(cache_repo_json_file)
            if Time.now - File.mtime(cache_repo_json_file) > 86400 # 60 * 60 * 24
              need_sync_repo = true
              puts "Cache for #{repo["url"]} is old."
            else
              response_data = File.read(cache_repo_json_file)
              repo_json_data = JSON.parse(response_data) rescue {}
            end
          else
            need_sync_repo = true
            puts "Cache for #{repo["url"]} no exist."
          end
        else
          puts "First time fetch #{repo["url"]}"
          need_sync_repo = true
        end

        if need_sync_repo
          puts "Sync project #{repo["url"]}"
          begin
            response_data_raw = URI.open(repo["url"]).read
          rescue OpenURI::HTTPError
            puts "Got error when fetch #{repo["url"]}:" + $!.message
            return nil
          end
          repo_json_data = JSON.parse(response_data_raw) rescue {}
          repo_id = repo_json_data["id"]
          File.open(File.expand_path("../../_data/repos/#{repo_id}.json", __FILE__), "w") do |f|
            f.write response_data_raw
          end
        end

        repo_json_data
      end

      def preate_data_for_project_page(site, page_name)
        puts site.data.inspect
        puts "Prepage data for page #{page_name}.html"
        projects_data = []
        need_dump = false
        site.data[page_name].each do |project_url_item|
            project_meta = {}
            project_url = project_url_item["url"]
            project_id = project_url_item["id"].to_i
            need_dump = (project_id == 0)
            if project_url.end_with?(".git")
              project_url.chomp!(".git")
            end
            if project_url.start_with?("https://github.com/")
                project_url.sub!("https://github.com/", "https://api.github.com/repos/")    
            end
            
            json_data = fetch_repo_data(project_url_item)
            if json_data
              project_meta["id"] = json_data["id"]
              project_meta["name"] = json_data["full_name"]
              project_meta["description"] = json_data["description"]
              project_meta["url"] = json_data["html_url"]
              project_meta["pushed_at"] = json_data["pushed_at"]
              project_meta["stargazers_count"] = json_data["stargazers_count"]
              projects_data << project_meta
            end
        end
        if need_dump && !projects_data.empty?
          projects_data_d = projects_data.clone
          projects_data_d.each do |p|
            p.delete(:description)
          end
          File.open(File.expand_path("../../_data/#{page_name}.yml", __FILE__), 'w') {|f| f.write projects_data_d.to_yaml } rescue nil
        end

        page_tpl = site.pages.find { |page| page.name == "#{page_name}.html"}
        puts "page_tpl:#{page_tpl.inspect}"
        if page_tpl
          page_tpl.data['projects'] = projects_data
        end
      end
      
      def generate(site)
        preate_data_for_project_page(site, "ruby_lang")
        preate_data_for_project_page(site, "rails_lib")
        preate_data_for_project_page(site, "rails_app")
        preate_data_for_project_page(site, "rails_front")
      end
    end
  end