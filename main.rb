#!/usr/bin/ruby -Ku

require 'discordrb'
require 'sequel'
require_relative 'lib/bcdice_wrapper.rb'

DATABASE = __dir__+"/database.sqlite"

bcdice = DiscordBCDiceMaker.new.newBcDice
bcdice.after_initialize

begin
    db = Sequel.sqlite(DATABASE)[:servers]
rescue => err
    puts err.message
    puts "maybe, you had not migration...had you?"
    exit 1
end

# load Discord bot clientID and token
# first line: client_id, second line: token
key = []
File.open("./token.txt").each_line do |line|
    key.push(line)
end

bot = Discordrb::Bot.new client_id: key[0].to_i, token: key[1].gsub(/\n/, '')

# server invited event
bot.server_create do |eve|
    id = eve.server.id
    db.insert(:server_id=>id, :system=>"None")
end

# server kicked event
bot.server_delete do |eve|
    id = eve.server.id
    db.where(:server_id=>id).delete
end

# Hello, bot
bot.message(contains: "こんにちは") do |eve|
  eve.respond "#{eve.user.name}さん、こんにちは"
end

bot.message(with_text: "!systemlist") do |eve|
  help_lines = bcdice.validSystemlist
  help_lines_before = help_lines[0..help_lines.size / 2].join("\n")
  help_lines_after = help_lines[(help_lines.size / 2)..help_lines.size].join("\n")
  eve.user.pm("```#{help_lines_before}```")
  eve.user.pm("```#{help_lines_after}```")
end

bot.message(with_text:"!systemhelp") do |eve|
  test_get_data = db.first(:server_id => eve.server.id)
  unless test_get_data.nil?
    bcdice.setGameByTitle(test_get_data[:system])
    eve.user.pm("```#{bcdice.getHelpMessage}```")
  end
end

# set system event
bot.message(contains: "set:") do |eve|
  system = (/^set:( *)(.+)/.match(eve.text))[2]
    unless bcdice.validSystem?(system)
      system = "None"
    else
      unless bcdice.systemlist[system].nil?
        system = bcdice.systemlist[system]
      end
    end

    if system == "None"
      eve.respond "#{eve.user.name}:ダイスが解除されました"
    else
      system.gsub!(/\n/, '')
      test_get_data = db.first(:server_id => eve.server.id)
      if test_get_data.nil?
        db.insert(:server_id => eve.server.id, :system => system)
      else
        db.where(:server_id => eve.server.id).update(:system => system)
      end
      eve.respond "#{eve.user.name}:ゲームが#{system}にセットされました"
    end
end

# dice roll event
bot.message(containing: not!("set:")) do |eve|
    bcdice.setNick(eve.user.name)
    if eve.server.nil?
      system = "DiceBot"
    else
      system = db.first(:server_id => eve.server.id)
      if system.nil?
        system = "DiceBot"
      else
        system = system[:system]
      end
    end
    bcdice.setGameByTitle(system)
    bcdice.setMessage(eve.text)
    message, _ = bcdice.dice_command
    if (message != "" && message != "1")
        eve.respond message
    end
end

bot.run
