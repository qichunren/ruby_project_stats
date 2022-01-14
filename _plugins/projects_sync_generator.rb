# Place this file into your jekyll site _plugins directory, it will auto used by jekyll command.
require "open-uri"
module RailsProjectStats
    
    class SyncGenerator < Jekyll::Generator
      
      def generate(site)
        projects_data = []
        need_dump = false
        site.data["project_urls"].each do |project_url_item|
            project_meta = {}
            project_url = project_url_item["url"]
            project_id = project_url_item["id"].to_i
            if project_url.end_with?(".git")
              project_url.sub!(".git", "")
            end
            if project_url.start_with?("https://github.com/")
                project_url.sub!("https://github.com/", "https://api.github.com/repos/")    
            end
            need_sync_repo = false
            response_data = nil
            if project_id > 0
              cache_repo_json = File.expand_path("../../_data/repos/#{project_id}.json", __FILE__)
              if File.exist?(cache_repo_json)
                if Time.now - File.mtime(cache_repo_json) > 86400 # 60 * 60 * 24
                  need_sync_repo = true
                  puts "#{project_url} old"
                else
                  response_data = File.read(cache_repo_json)
                  json_data = JSON.parse(response_data) rescue {}
                end
              else
                need_sync_repo = true
                puts "#{cache_repo_json} no exist"
              end
            else
              need_sync_repo = true
              need_dump = true
              puts "#{project_url} new added first"
            end

            if need_sync_repo
              puts "Sync project #{project_url}"
              begin
                response_data = URI.open(project_url).read
              rescue OpenURI::HTTPError
                puts "Got error:" + $!.message
                next
              end
              json_data = JSON.parse(response_data) rescue {}
              repo_id = json_data["id"]
              File.open(File.expand_path("../../_data/repos/#{repo_id}.json", __FILE__), "w") do |f|
                f.write response_data
              end
            end

            #puts response_data
            project_meta["id"] = json_data["id"]
            project_meta["name"] = json_data["full_name"]
            project_meta["url"] = json_data["clone_url"]
            project_meta["pushed_at"] = json_data["pushed_at"]
            project_meta["stargazers_count"] = json_data["stargazers_count"]
            projects_data << project_meta
        end
        if need_dump
          File.open(File.expand_path("../../_data/project_urls.yml", __FILE__), 'w') {|f| f.write projects_data.to_yaml } rescue nil
        end
        puts "Info:" + projects_data.inspect
        stats_tpl = site.pages.find { |page| page.name == 'stats.html'}
        stats_tpl.data['projects'] = projects_data
      end
    end
  end