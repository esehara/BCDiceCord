#!/usr/bin/env ruby -Ku
#--*-coding:utf-8-*--

$LOAD_PATH << __dir__+"/bcdice/src/"
require 'cgi'
require_relative 'bcdice/src/bcdiceCore.rb'
require_relative 'bcdice/src/configBcDice.rb'

class DiscordBCDiceMaker < BCDiceMaker
    def newBcDice
        bcdice = DiscordBCDice.new(self, @cardTrader, @diceBot, @counterInfos, @tableFileData)
        return bcdice
    end
end

class DiscordBCDice < BCDice

    def setNick(nick)
        @nick_e = nick
    end

    def validSystem?(system)
        $allGameTypes.include?(system)
    end

end
