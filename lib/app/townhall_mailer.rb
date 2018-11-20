require 'gmail'
require 'googleauth'
require 'gmail_xoauth'
require 'fileutils'
require 'json'
require_relative 'db_interface'
require 'dotenv'

Dotenv.load("../../.env")
#Nous initialisons les différentes gem qui votn nous servir tout au long de la class mailer
class Mailer

  def initialize
      @contacts = JsonInterface.get_datas_from_json_file("db/contacts.json")
      # On récupère les contacts dans le fichier contacts.json auxquelles on va envoyer le mail?
      @adresse_mail = 'thehackingproject.lille@gmail.com'
      @mdp = '******'

      send_emails #appel de la méthode pour envoyer les mails
  end


# Cette méthode nous permet de se connecter au compte Gmail de THP Lille et d'envoyer un mail aux adresses mails présentes dans le fichier contacts.json
  def send_mail_to_townhall(contact)
    gmail = Gmail.connect!(@adresse_mail,@mdp)
    gmail.deliver do
      to  contact["email"]
      subject " Présentation de The Hacking Project "
      html_part do
        content_type 'text/html; charset=UTF-8'
         body
          "Bonjour,</br>
               Nous sommes élèves à The Hacking Project, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de ntore école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code. Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.</br>
               Déjà 500 personnes sont passées par The Hacking Project. Est-ce que vous voulez changer le monde avec nous ?</br>
               Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80</br>
               Excellente journée à vous,</br>
               La team Lille de The Hacking Project </br>"
      end
    end
  end

  def send_emails
    # cette méthode nous permet d'envoyer les mails en utilisant la méthode send_mail_to_townhall et le fichier contacts.json
    @contacts.each do |contact|
      send_mail_to_townhall(contact)
      puts "Email envoyé à #{contact['name']}"
      sleep 0.1
    end
  end
end
