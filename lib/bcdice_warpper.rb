#!/usr/bin/env ruby -Ku
#--*-coding:utf-8-*--

require 'cgi'
require 'bcdice/src/bcdiceCore.rb'
require 'bcdice/src/configBcDice.rb'

class AzusaBCDiceMaker < BCDiceMaker
    def newBcDice
        bcdice = OnsetBCDice.new(self, @cardTrader, @diceBot, @counterInfos, @tableFileData)
        return bcdice
    end
end

class AzusaBCDice < BCDice

    def setNick(nick)
        @nick_e = nick
    end

    def validSystem?(system)
        $allGameTypes.include?(system)
    end

end
