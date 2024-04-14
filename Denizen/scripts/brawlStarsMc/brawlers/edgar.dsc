bs_edgar_fight:
    type: item
    display name: <&f>Fight Club
    material: stone_axe
    mechanisms:
        hides: all
        custom_model_data: 103
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 20
                    slot: hand
        unbreakable: true
    flags:
        atk: edgar.atk

edgar:
    type: task
    debug: false
    script:
        - definemap data:
            health: 3700
            health_scale: 370
            speed: 820
            ammo: 3
            reloadSpeed: 0.7
            rarity: epic

            charDesc: "Edgar believes nobody understands him. Certainly not his mom, who thinks he's going through a phase. Only he knows the darkness in his soul is eternal."

            atk: bs_edgar_fight
            atkRange: 2
            atk_base: 540
            atk_ult_charge: 8.37
            atk_scale: 54

            heal_base: 189
            heal_scale: 18

            ult: edgar.ult
            ult_name: Vault
            ultRange: 6.67
            ult_ult_charge: 0
            ult_base: 0
            ult_scale: 0
        - flag <player> bs.trait.cot
        - flag <player> bs.thrower
    atk:
        - flag <player> bs.shotDelay expire:10s
        - inject edgar
        - define loc <player.eye_location.below[0.3].with_pitch[0]>
        - definemap arc:
            location: <[loc].forward_flat[0.3]>
            radius: 1
            rotation: 0
            points: 50
            arc: 180
        - define arc <[arc].proc[circg].reverse>
        - foreach <[arc]> as:p:
            - playeffect effect:redstone special_data:0.25|#87ebfa at:<[p]> offset:0.2,0,0.2 quantity:5
            - if <[loop_index].mod[13]> == 0:
                - wait 1t
        - define beam <player.eye_location.below[0.3].left[0.3].points_between[<player.eye_location.below[0.3].left[0.3].forward_flat[<[data.atkRange]>]>].distance[0.1]>
        - foreach <[beam]> as:p:
            - playeffect effect:redstone special_data:0.8|#87ebfa at:<[p]> offset:0.01 quantity:1
            - if <[loop_index].mod[8]> == 0:
                - wait 1t
        - define ents <[arc].get[<[arc].size.div[2].round_down>].find_entities.within[1].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - define loc <player.eye_location.below[0.3].with_pitch[0]>
        - definemap arc:
            location: <[loc].forward_flat[0.3]>
            radius: 1
            rotation: 0
            points: 50
            arc: 180
        - define arc <[arc].proc[circg].reverse>
        - foreach <[arc].reverse> as:p:
            - playeffect effect:redstone special_data:0.25|#87ebfa at:<[p]> offset:0.2,0,0.2 quantity:5
            - if <[loop_index].mod[13]> == 0:
                - wait 1t
        - define ents <[arc].get[<[arc].size.div[2].round_down>].find_entities.within[1].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - define beam <player.eye_location.below[0.3].right[0.3].points_between[<player.eye_location.below[0.3].right[0.3].forward_flat[<[data.atkRange]>]>].distance[0.1]>
        - foreach <[beam]> as:p:
            - playeffect effect:redstone special_data:0.8|#87ebfa at:<[p]> offset:0.01 quantity:1
            - if <[loop_index].mod[8]> == 0:
                - wait 1t
        - flag <player> bs.shotDelay:!
    ult:
        - inject edgar
        - flag <player> bs.shotDelay expire:10s
        - spawn item_display[item=air] <player.location> save:dis
        - define dis <entry[dis].spawned_entity>
        - if <player.has_flag[bs.thrower_active]>:
            - define arc <player.flag[bs.thrower_active.arc]>
            - teleport <player> <player.flag[bs.thrower_active.npc].location>
            - remove <player.flag[bs.thrower_active.cam]>
            - remove <player.flag[bs.thrower_active.npc]>
            - flag <player> bs.thrower_active:!
            - cast invisibility remove
        - else:
            - define arcEnd <player.eye_location.forward[<[data.ultRange]>].with_pitch[90].with_y[<player.location.y>].ray_trace[range=10]>
            - if <[arcEnd].find_blocks[water].within[1.5].any> || <[arcEnd].y.abs> <= <player.flag[bs.thrower_active.npc].location.y.abs>:
                - repeat 10:
                    - define arcEnd <[arcEnd].with_yaw[<player.location.yaw>].with_pitch[0].forward[1].with_pitch[90].with_y[<player.location.y>].ray_trace[range=10]>
                    - repeat stop if:<[arcEnd].y.abs.round_down.is_more_than_or_equal_to[<player.flag[bs.thrower_active.npc].location.y.abs.round_down>].and[<[arcEnd].find_blocks[water].within[1.5].any.not>]>
            - define arc <proc[bezier_arc].context[<player.location.below[4].forward_flat[1]>|<[arcEnd]>|10|150]>
        - mount <player>|<[dis]>
        - define timepassed <util.time_now>
        - foreach <[arc]> as:p:
            - adjust <[dis]> teleport_duration:1t
            - teleport <[dis]> <[p]>
            - if <[loop_index].mod[12]> == 0:
                - wait 1t
        - wait 6t
        - flag <player> bs.shotDelay:!
        - remove <[dis]>
        - adjust <player> speed:<element[1200].proc[speedCalc]>
        - wait 2.5s
        - adjust <player> speed:<[data.speed].proc[speedCalc]>
    visualize:
        - while <player.has_flag[bs.thrower_active]>:
            - inject edgar
            - define arcEnd <player.eye_location.forward[<[data.ultRange]>].with_pitch[90].with_y[<player.location.y>].ray_trace[range=10]>
            - if <[arcEnd].find_blocks[water].within[1.5].any> || <[arcEnd].y.abs> <= <player.flag[bs.thrower_active.npc].location.y.abs>:
                - repeat 10:
                    - define arcEnd <[arcEnd].with_yaw[<player.location.yaw>].with_pitch[0].forward[1].with_pitch[90].with_y[<player.location.y>].ray_trace[range=10]>
                    - repeat stop if:<[arcEnd].y.abs.round_down.is_more_than_or_equal_to[<player.flag[bs.thrower_active.npc].location.y.abs.round_down>].and[<[arcEnd].find_blocks[water].within[1.5].any.not>]>
            - define arc <proc[bezier_arc].context[<player.location.below[4].forward_flat[1]>|<[arcEnd]>|10|150]>
            - flag <player> bs.thrower_active.arc:<[arc]>
            - playeffect effect:redstone special_data:0.1|#cacccf offset:0.01 at:<[arc]> quantity:4 targets:<player>
            - playeffect effect:redstone special_data:0.3|#cacccf offset:0.03 at:<[arc].last.backward_flat[1].left[0.5].points_between[<[arc].last.right[0.5]>].distance[0.2]> quantity:4 targets:<player>
            - playeffect effect:redstone special_data:0.3|#cacccf offset:0.03 at:<[arc].last.backward_flat[1].right[0.5].points_between[<[arc].last.left[0.5]>].distance[0.2]> quantity:4 targets:<player>
            - wait 1t

bs_edgar_handler:
    type: world
    debug: false
    events:
        on player steers entity flagged:bs.shotDelay:
            - if <context.dismount>:
                - determine passively cancelled