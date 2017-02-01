#!/usr/bin/ruby -Ku

require 'discordrb'
require 'sequel'
require_relative 'lib/bcdice_wrapper.rb'

DATABASE = __dir__+"/database.sqlite"

bcdice = DiscordBCDiceMaker.new.newBcDice
db = Sequel.sqlite(DATABASE)[:servers]

# load Discord bot clientID and token
# first line: client_id, second line: token
key = []
File.open("./token.txt").each_line do |line|
    key.push(line)
end

bot = Discordrb::Bot.new client_id: key[0].to_i, token: key[1]

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

# set system event
bot.message(contains: "set:") do |eve|
    system = eve.text.slice("set:")
    unless bcdice.validSystem?(txt)
        system = "None"
    end

    db.where(:server_id =>eve.server.id)
        .update(:server_id=>eve.server.id, :system=>system)
    
    if(system == "None")
        eve.respond "#{eve.user.name}:ダイスが解除されました"
    else
        eve.respond "#{eve.user.name}:ゲームが#{system}にセットされました"
    end
end

# dice roll event
bot.message(containing: not!("set:")) do |eve|
    bcdice.setNick(eve.user.name)
    system = db.where(:server_id => eve.server.id).get(:system)
    bcdice.setGameByTitle(system)
    bcdice.setMessage(eve.text)
    hoge, foo = bcdice.dice_command
    if(hoge != "")
        eve.respond hoge
    end
end

bot.run