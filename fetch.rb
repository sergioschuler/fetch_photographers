require 'mechanize'

agent = Mechanize.new
url = 'http://www.fearlessphotographers.com/best-wedding-photographers-directory.cfm' 

agent.get(url)
agent.page.links_with(text: /All areas/).each do |link|
	link.click
	if agent.page.links_with(text: /View Full Profile/)
		agent.page.links_with(text: /View Full Profile/).each do |link|
			link.click
			name = agent.page.at("h1").text.split
			if agent.page.link_with(text: /^([0-9a-zA-Z]([-\.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/)
				email = agent.page.link_with(text: /^([0-9a-zA-Z]([-\.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/)
				if email.text.split("@").last
					website = email.text.split("@").last
				else
					website = nil
				end
			else
				email = nil
			end		
			location = agent.page.links_with(:href => /\/location.+/).last
			if agent.page.at(".profile-header")
				fearless_awards = agent.page.at(".profile-header").text
			else
				fearless_awards = 0
			end
			File.open("photographers.csv", "a") do |w|
				w.write "#{name[0]}; #{name[1]}; #{email}; #{website}; #{location}; #{location.uri}; #{fearless_awards}\n"
			end
		end
	end	
end


