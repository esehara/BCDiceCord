#!/usr/bin/ruby -Ku

$LOAD_PATH.push(__dir__)
require 'discordrb'
require 'sequel'
require 'bcdice_wrapper.rb'
require 'db.rb'

DATABASE = __dir__+"/database.sqlite"

bcdice = DiscordBCDiceMaker.new.newBcDice
db = Sequel.sqlite(DATABASE)[:channels]

# load Discord bot clientID and token
# first line: client_id, second line: token
key = []
File.open("./token.txt").each_line do |line|
    key.push(line)
end

bot = Discordrb::Bot.new client_id: key[0].to_i, token: key[1]

# set system event
bot.message(contains: "set:") do |eve|
    system = eve.text.slice("set:")
    unless bcdice.validSystem?(txt)
        system = "None"
    end

    db.where(:channel_id =>eve.channel.id)
        .update(:channel_id=>eve.channel.id, :system=>system)
    
    if(system == "None")
        eve.respond "#{eve.user.name}:ダイスが解除されました"
    else
        eve.respond "#{eve.user.name}:ゲームが#{system}にセットされました"
    end
end

# dice roll event
bot.message(containing: not!("set:")) do |eve|
    bcdice.setNick(eve.user.name)
    system = db.where(:channel_id => eve.channel.id).get(:system)
    bcdice.setGameByTitle(system)
    bcdice.setMessage(eve.text)
    hoge, foo = bcdice.dice_command
    if(hoge != "")
        eve.respond hoge
    end
end

bot.run