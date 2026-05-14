AxTackleConfig = {}

-- Notification type to use for cooldown messages.
AxTackleConfig.NotificationType = 'axionnotification' -- 'chat' or 'axionnotification' (if you have AxionNotifications resource)

-- Maximum distance in units for a tackle to be successful.
AxTackleConfig.MaximumDistance = 2.0

-- Cooldown in seconds on use of tackles
AxTackleConfig.Cooldown = 10

-- Whether players should be disarmed when tackled.
AxTackleConfig.DisarmOnTackle = true

-- Whether tackles can be resisted by the target.
AxTackleConfig.Resistable = false

-- Keys that can be used to resist tackles. Default is 'W' for forward movement.
AxTackleConfig.ResistKeys = {'W'}

-- Emotes that when active, does not allow players to tackle.
AxTackleConfig.RestrictedEmotes = {
    {
        dict = 'mp_arrest_paired',
        anim = 'crook_p2_back_right'
    },
    {
        dict = 'random@mugging3',
        anim = 'handsup_standing_base'
    }
}