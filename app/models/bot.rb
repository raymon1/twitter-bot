class Bot < ActiveRecord::Base
	def self.search_words words
		CLIENT.search(words, lang: "en").first.text
	end

	def self.respond name
		"@" + name + " " + Response.order_by_rand.first.message
	end

	def self.find_user words, number
		CLIENT.search(words, lang: "en").take(number).each do |t|
			User.create(name: t.user.screen_name ,tweet_id: t.id.to_s)
			CLIENT.update(Bot.respond(t.user.screen_name), in_reply_to_status_id: t.id)
		end
	end

	def self.start
		while true
			begin
				Bot.find_user("hug", 1)
				puts "a user was hugged"
				sleep 120
			rescue
				puts "error happened, sleeping for extra 5 seconds"
				sleep 5
			end
		end
	end
end
