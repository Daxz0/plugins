worldLoader:
    type: world
    debug: false
    events:
        on server start:
            - createworld bsmaps
        on player breaks block priority:10:
            - determine passively cancelled if:<player.gamemode.equals[creative].not>

        on player joins priority:10:
            - teleport <player> <world[bsmaps].spawn_location>
            - feed <player> amount:-14 saturation:20
            # - cast fast_digging amplifier:99999999999999 duration:-1t no_ambient no_icon no_clear hide_particles
        #on player right clicks barrel|chest priority:10:
            #- determine passively cancelled