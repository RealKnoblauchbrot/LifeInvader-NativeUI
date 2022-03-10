Config = {
    webhook = "change this", --Discord Webhook
    cost = 150, -- How much should the Player need to pay.
    cooldown = 1.2, -- Cooldown in Minutes
    pedModel = "ig_lifeinvad_01",
    name     = "LifeInvader",
    blips = {
        sprite  = 77,
        color   = 1,
        scale   = 0.66
    },
    locations = {
        {
            coords = vector3(-1083.47, -245.96, 37.76), -- No need to substract the Z coordinate by 1.
            heading = 208.65
        }
    },
    locale = {
        PressE = "Press ~INPUT_PICKUP~ to use the LifeInvader. ~n~(Cost: ~g~$%s~s~)",
        Menu = {
            title           = "LifeInvader",
            description     = "Post something Globally!",
            SendTitle       = "Send a message to every citizen in the state!",
            SendDescription = "To send a message you will need to pay $%s.",
        },
        adDescription = "Advertisement",
        NotEnoughMoney  = "You don't have enough money!",
        CurrentlyOnCooldown = "There is currently still a cooldown. ~n~Time Left: %sminutes",
        PostedAdvertisementLog = "**[LifeInvader] %s posted an advertisement.**"
    }

}