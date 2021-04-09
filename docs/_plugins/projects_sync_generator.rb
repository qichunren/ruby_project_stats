# Place this file into your jekyll site _plugins directory, it will auto used by jekyll command.
require "open-uri"
module RailsProjectStats
    
    class SyncGenerator < Jekyll::Generator
      
      def generate(site)
        projects_data = []
        site.data["project_urls"].each do |project_url_item|
            project_meta = {}
            project_url = project_url_item["url"]    
            if project_url.start_with?("https://github.com/")
                project_url.sub!("https://github.com/", "https://api.github.com/repos/")    
            end
            puts "Sync project #{project_url}"
            begin
                response_data = open(project_url).read
            rescue OpenURI::HTTPError
                puts "Got error:" + $!.message
                next
            end
            #puts response_data
            json_data = JSON.parse(response_data) rescue {}
            project_meta["name"] = json_data["name"]
            project_meta["url"] = json_data["clone_url"]
            project_meta["pushed_at"] = json_data["pushed_at"]
            project_meta["stargazers_count"] = json_data["stargazers_count"]
            projects_data << project_meta
        end
        puts "Info:" + projects_data.inspect
        stats_tpl = site.pages.find { |page| page.name == 'stats.html'}
        stats_tpl.data['projects'] = projects_data
      end
    end
  end