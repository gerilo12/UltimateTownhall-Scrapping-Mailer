require 'dotenv'
require 'twitter'
require 'json'
require_relative 'db_interface'

Dotenv.load

class TownhallTwitter
  def initialize # A l'initialisation, on créé le client twitter
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["THPLILLE_CONFIG_KEY"]
      config.consumer_secret     = ENV["THPLILLE_CONFIG_SECRET"]
      config.access_token        = ENV["THPLILLE_TOKEN_KEY"]
      config.access_token_secret = ENV["THPLILLE_TOKEN_SECRET"]
    end
    # Et on récupère la liste des contacts
    @contacts = JsonInterface.get_datas_from_json_file('db/contacts.json')
  end

  def update_contacts_in_json
    @contacts.each do |contact| # POur chaque contact (hash)
      handle = get_handle(contact['name']) if contact # Je récupère le @handle (le if est préventif au cas ou un contact est nil)
      contact["twitter"] = handle if handle # Si le handle existe (si la mairie a un compte twitter), je l'ajoute aux infos du contact
    end
    JsonInterface.save_into_json_file(@contacts, 'db/contacts.json') # Je sauvegarde la liste de contacts modifiés (format json)
  end

  def get_handle(town)
    # Je fais une recherche twitter "mairie + nom de la ville"
    handle = @client.user_search("mairie #{town}") if town # je récupère un tableau de résultats (if préventif, comme au dessus)
    if handle != [] # SI le tableau n'est pas vide (j'ai trouvé des comptes avec ma recherche)
      return handle[0].screen_name # Je return le @screen_name (le nom visible du compte qui commence par @) du 1er résultat
    end
  end

  def how_many_townhall_use_twitter
    counter = 0
    @contacts.each do |contact| # Pour chaque contact
      if contact != nil # if préventif
        counter += contact.keys.count do |k| # Je compte le nombre de mes contacts ayant un compte twitter
          k.include?('twitter') # En regardant simplement si la clé "twitter" existe dans la fiche du contact
        end
      end
    end
    counter # Je return counter
  end

  def print_contacts_if_twitter
    # J'affiche tous les contacts possédant un compte twitter
    @contacts.each do |contact|
      if contact != nil && contact.keys.include?('twitter')
        puts "La commune de #{contact['name']} se trouve dans le département du #{contact['region']} !"
        puts "Tu peux la contacter par mail à l'adresse suivante : #{contact['email']} ou sur twitter @#{contact['twitter']}."
      end
    end
  end

  def follow_twitter_accounts
    # Je créé un array des comptes que je souhaite follow
    to_follow = []
    @contacts.each do |contact| # Pour chaque contact
      if contact != nil && contact.keys.include?('twitter') # S'il a un compte twitter
        to_follow << client.user(contact['twitter']) # Je récupère son id user à partir du screen_name et je l'ajoute au array
      end
    end
    client.follow(to_follow) # Je follow tous les users de mon array
  end
end
