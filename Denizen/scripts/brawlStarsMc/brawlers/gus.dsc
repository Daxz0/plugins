bs_gus_balloon:
    type: item
    display name: <&f>Loony Balloons
    material: stone_axe
    mechanisms:
        hides: all
        custom_model_data: 101
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 20
                    slot: hand
        unbreakable: true
    flags:
        atk: gus.atk

bs_gus_spirit:
    type: item
    debug: false
    material: light_blue_stained_glass
    mechanisms:
        custom_model_data: 2

gus:
    type: task
    debug: false
    script:
        - definemap data:
            health: 3200
            health_scale: 320
            speed: 720
            ammo: 3
            reloadSpeed: 1.5
            rarity: super_rare

            charDesc: "Gus looks so much like a ghost child that he's often mistaken for one. Perhaps fittingly, he's an enthusiast of all things Supernatural, since he's too innocent to be scared."

            atk: bs_gus_balloon
            atkRange: 7.67
            atk_base: 1000
            atk_ult_charge: 25
            atk_scale: 100

            heal: gus.healPickup
            heal_base: 800
            heal_scale: 80

            ult: gus.ult
            ult_name: Spooky Boy
            ultRange: 9.33
            ult_ult_charge: 0
            ult_base: 2600
            ult_scale: 260
    atk:
        - inject gus
        - animate animation:ARM_SWING for:<player>
        - flag <player> bs.shotDelay expire:10s
        - define loc <player.eye_location.below[0.5].with_pitch[0]>
        - define beam <[loc].points_between[<[loc].forward[<[data.atkRange]>]>].distance[0.1]>
        - if <player.flag[bs.gusbar]> >= 0.99:
            - foreach <[beam]> as:p:
                - define circ <location[0,0,0,<player.world.name>].to_ellipsoid[5,5,5].shell.parse[mul[0.05].add[<[p].xyz>]]>
                - playeffect effect:redstone special_data:0.15|#f8ff2b offset:0 quantity:1 at:<[circ]> visibility:1000000
                - define ents <[p].find_entities.within[0.1].exclude[<player>]>
                - if <[ents].any>:
                    - define locy <[ents].first.location>
                    - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
                    - flag <player> bs.gusbar:!
                    - drop bs_gus_spirit <[locy]> save:spirit
                    - flag <entry[spirit].dropped_entity> owner:<player>
                    - foreach stop
                - if <[loop_index].mod[4]> == 0:
                    - wait 1t
        - else:
            - foreach <[beam]> as:p:
                - define circ <location[0,0,0,<player.world.name>].to_ellipsoid[5,5,5].shell.parse[mul[0.05].add[<[p].xyz>]]>
                - playeffect effect:redstone special_data:0.15|#64c0f5 offset:0 quantity:1 at:<[circ]> visibility:1000000
                - define ents <[p].find_entities[living].within[0.1].exclude[<player>]>
                - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
                - foreach stop if:<[ents].any>
                - if <[loop_index].mod[4]> == 0:
                    - wait 1t
        - flag <player> bs.shotDelay:!
    ult:
        - inject gus
        - define target <player.eye_location.ray_trace_target[range=<[data.ultRange]>;raysize=2;ignore=<player>;entities=player].if_null[<player>]>
        - if <player.scoreboard_team_name> == <[target].scoreboard_team_name> && <[target]> != <player>:
            - define target <[target]>
        - else:
            - define target <player>

        - spawn item_display[item=light_blue_stained_glass[custom_model_data=1];translation=0,-1.3,0;scale=1.2,1.2,1.2] save:dis <[target].location.with_pitch[0].with_yaw[0]>
        - spawn text_display[text=<[data.ult_base]>;pivot=center;background_color=<color[#ffffff].with_alpha[0]>;translation=0,0.5,0;scale=1.2,1.2,1.2] save:txt <[target].location.with_pitch[0].with_yaw[0]>
        - definemap shielddata:
            tothealth: <[data.ult_base]>
            health: <[data.ult_base]>
            text: <entry[txt].spawned_entity>
            shield: <entry[dis].spawned_entity>
        - flag <[target]> bs.decay_shield:<[shielddata]> expire:<[data.ult_base].mul[0.0025]>
        - mount <entry[txt].spawned_entity>|<entry[dis].spawned_entity>|<[target]>
        - look <entry[dis].spawned_entity> yaw:0 pitch:0

    gus_bar:
        - if <[player].flag[bs.character]> == gus:
            - flag <[player]> bs.gusbar:+:0.33
            - if <[player].flag[bs.gusbar]> >= 1:
                - flag <[player]> bs.gusbar:!
                - bossbar remove gusbar_<[player]> players:<[player]>
                - stop
            - if <[player].flag[bs.gusbar]> >= 0.99:
                - flag <[player]> bs.gusbar:1
                - bossbar gusbar_<[player]> players:<[player]> "title:<&b>Spirits Bar" progress:<player.flag[bs.gusbar].round_up_to_precision[0.1]> color:yellow
                - stop
            - bossbar gusbar_<[player]> players:<[player]> "title:<&b>Spirits Bar" progress:<player.flag[bs.gusbar].round_up_to_precision[0.1]> color:yellow

gus_handler:
    type: world
    debug: false
    events:
        on player quits flagged:bs.decay_shield:
            - define data <player.flag[bs.decay_shield]>
            - remove <[data.text]>
            - remove <[data.shield]>
        on player picks up bs_gus_spirit:
            - determine passively cancelled
            - if <context.entity.flag[owner]> == <player> || <context.entity.flag[owner].scoreboard_team_name.if_null[0]> == <player.scoreboard_team_name.if_null[1]>:
                - inject <player.flag[bs.character]>
                - if <player.flag[bs.hp]> >= <[data.health]>:
                    - stop
                - inject gus
                - if <player.flag[bs.hp]> >= <[data.heal_base]>:
                    - flag <player> bs.hp:+:<player.flag[bs.hp].sub[<[data.heal_base]>]>
                - else:
                    - flag <player> bs.hp:+:<[data.heal_base]>
                - wait 3t
                - remove <context.entity>