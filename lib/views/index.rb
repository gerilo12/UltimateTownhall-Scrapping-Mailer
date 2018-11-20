class Menu

	def initialize
		puts "Bonjour, Entrez :"
		puts "1 pour recuperer les emails des mairies des trois departements du Nord, du Pas de Calais et de la Seine maritime"
		puts "2 pour envoyer des mails à ces mairies"
		puts "3 pour ajouter à la liste de contact un compte twitter s'il y en a un. Attention, cette action mènera à un bannissement de ton compte twitter..."
		puts "4 pour connaitre combien de communes ont un compte twitter"
		puts "5 pour en avoir la liste"
		puts "6 pour les follow sur twitter"
		print "Que voulez-vous faire ? > "
		choice
	end

	def choice
		choice = gets.chomp.to_i
		case choice
		when 1 then Scrapper.new
		when 2 then Mailer.new
		when 3
			puts ' /!/ Warning /!/ Cette action est très longue et aboutira par un bannissement de ton compte twitter avant la fin de l\'opération, elle est par conséquente très fortement déconseillé !'
			print "Veux tu continuer malgré tout ? (y/n) : "
			rep = gets.chomp
			if rep == 'y'
				puts "Tu l'auras voulu ... C'est parti"
				TownhallTwitter.new.update_contacts_in_json
			end
		when 4
			puts "Sur toutes les communes des 3 départements scrappés, seuls #{TownhallTwitter.new.how_many_townhall_use_twitter} ont un compte twitter !"
		when 5
			puts "Voici la liste des communes ayant twitter :"
			TownhallTwitter.new.print_contacts_if_twitter
		when 6
			puts "Les comptes twitters sont déja follow (voir sur https://twitter.com/thplille)"
			puts "Mais rien ne nous empeche de relancer la méthode :)"
			TownhallTwitter.new.follow_twitter_accounts
		else
			puts "Je n'ai pas compris, recommence !"
			print "Que veux-tu faire ? :"
			self.choice
		end
		puts
		puts "Ton voeu précédent est maintenant accompli, souhaites-tu en faire un autre ? (y/ctrl-c)"
		print "Ne t'inquiètes pas, je ne suis pas un génie, tu ne seras pas limité à 3 voeux : "
		rep = gets.chomp
		if rep =='y'
			self.choice
		end
	end
end
