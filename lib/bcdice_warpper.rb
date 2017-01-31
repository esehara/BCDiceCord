#!/usr/bin/env ruby -Ku
#--*-coding:utf-8-*--

require 'cgi'
require 'bcdice/src/bcdiceCore.rb'
require 'bcdice/src/configBcDice.rb'

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
