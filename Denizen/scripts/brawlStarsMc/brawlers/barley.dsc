bs_barley_bottle:
    type: item
    display name: <&f>Undiluted
    material: stone_axe
    mechanisms:
        hides: all
        custom_model_data: 102
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 20
                    slot: hand
        unbreakable: true
    flags:
        atk: barley.atk
        thrower: true


barley:
    type: task
    debug: false
    script:
        - definemap data:
            health: 2400
            health_scale: 420
            speed: 720
            ammo: 3
            reloadSpeed: 2
            rarity: rare

            charDesc: "A bartending robot designed to mix drinks and banter with patrons, Barley also makes sure to keep his bar clean, to the detriment of anyone who makes a mess."

            atk: bs_barley_bottle
            atkRange: 7.33
            atk_base: 760
            atk_ult_charge: 17
            atk_scale: 76

            ult: barley.ult
            ult_name: Last Call
            ultRange: 9.33
            ult_ult_charge: 14
            ult_base: 760
            ult_scale: 76
        - flag <player> bs.thrower
    atk:
        - inject barley
        - spawn item_display[item=bs_barley_bottle] <player.location> save:bot
        - define bottle <entry[bot].spawned_entity>

        - if <player.has_flag[bs.thrower_active.arc]>:
            - define arc <player.flag[bs.thrower_active.arc]>
            - foreach <[arc]> as:p:
                - teleport <[bottle]> <[p].face[<[bottle].location>]>
                - if <[loop_index].mod[5]> == 0:
                    - wait 1t
        - else:
            - define arcEnd <player.eye_location.forward[<[data.atkRange]>].with_pitch[90].with_y[<player.location.y>]>
            - define arc <proc[bezier_arc].context[<player.location.above[0.8].forward_flat[1]>|<[arcEnd]>|10|150]>
            - foreach <[arc]> as:p:
                - teleport <[bottle]> <[p].face[<[bottle].location>]>
                - if <[p].y.abs> >= <player.location.y.abs> && <[loop_index]> > <[arc].size.div[3]>:
                    - define endLoc <[p].above[0.6]>
                    - foreach stop
                - if <[loop_index].mod[5]> == 0:
                    - wait 1t
        - wait 1t
        - remove <[bottle]>
        - if <[endLoc].exists.not>:
            - define endLoc <[arc].last.with_pitch[90].ray_trace[range=10].above[0.6]>
        - playeffect effect:block_crack special_data:lime_stained_glass <[endLoc].below[0.5]> offset:0.25,0.05,0.25 quantity:35
        - definemap brightness:
            block: 15
            sky: 15
        - spawn item_display[item=lime_stained_glass_pane[custom_model_data=101];scale=1.5,1,1.5;brightness=<[brightness]>] <[endLoc]> save:pud
        - look <entry[pud].spawned_entity> yaw:0 pitch:0
        - define ents <[endLoc].find_entities[living].within[2].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - wait 1s
        - define ents <[endLoc].find_entities[living].within[2].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - wait 0.9s
        - remove <entry[pud].spawned_entity>
    ult:
        - inject barley
        - define loc <player.eye_location>
        - define arcEnd <[loc].forward[<[data.ultRange]>].with_pitch[90].ray_trace[range=25]>
        - run barley_ult_spread def:<[arcEnd]>
        - wait 5t
        - define arcEnd <[loc].forward[<[data.ultRange].add[2.5]>].left[2.5].with_pitch[90].ray_trace[range=25]>
        - run barley_ult_spread def:<[arcEnd]>
        - wait 5t
        - define arcEnd <[loc].forward[<[data.ultRange].add[2.5]>].right[2.5].with_pitch[90].ray_trace[range=25]>
        - run barley_ult_spread def:<[arcEnd]>
        - wait 5t
        - define arcEnd <[loc].forward[<[data.ultRange].sub[2.5]>].left[2.5].with_pitch[90].ray_trace[range=25]>
        - run barley_ult_spread def:<[arcEnd]>
        - wait 5t
        - define arcEnd <[loc].forward[<[data.ultRange].sub[2.5]>].right[2.5].with_pitch[90].ray_trace[range=25]>
        - run barley_ult_spread def:<[arcEnd]>
    visualize:
        - while <player.has_flag[bs.thrower_active]>:
            - inject barley
            - define arcEnd <player.eye_location.forward[<[data.atkRange]>].with_pitch[90].with_y[<player.location.y>].ray_trace[range=10]>
            - define arc <proc[bezier_arc].context[<player.location.below[4].forward_flat[1]>|<[arcEnd]>|10|150]>
            - flag <player> bs.thrower_active.arc:<[arc]>
            - playeffect effect:redstone special_data:0.1|#cacccf offset:0.01 at:<[arc]> quantity:2 targets:<player>
            - playeffect effect:redstone special_data:0.3|#cacccf offset:0.03 at:<[arc].last.backward_flat[1].points_around_y[radius=2;points=50]> quantity:2 targets:<player>
            - wait 1t

barley_ult_spread:
    type: task
    debug: false
    definitions: arcEnd
    script:
        - inject barley
        - spawn item_display[item=bs_barley_bottle] <player.location> save:bot
        - define bottle <entry[bot].spawned_entity>
        - if <player.has_flag[bs.thrower_active]>:
            - define arc <proc[bezier_arc].context[<player.location.below[4].forward_flat[1]>|<[arcEnd]>|10|150]>
            - foreach <[arc]> as:p:
                - teleport <[bottle]> <[p].face[<[bottle].location>]>
                - if <[p].material.is_solid> && <[loop_index]> > <[arc].size.div[3]>:
                    - define endLoc <[p].above[0.6]>
                    - foreach stop
                - if <[loop_index].mod[5]> == 0:
                    - wait 1t
        - else:
            - define arc <proc[bezier_arc].context[<player.location.above[0.8].forward_flat[1]>|<[arcEnd]>|10|150]>
            - foreach <[arc]> as:p:
                - teleport <[bottle]> <[p].face[<[bottle].location>]>
                - if <[p].y.abs> >= <player.location.y.abs> && <[loop_index]> > <[arc].size.div[3]>:
                    - define endLoc <[p].above[0.6]>
                    - foreach stop
                - if <[loop_index].mod[5]> == 0:
                    - wait 1t
        - remove <[bottle]>
        - if <[endLoc].exists.not>:
            - define endLoc <[arc].last.with_pitch[90].ray_trace[range=10].above[0.6]>
        - playeffect effect:block_crack special_data:lime_stained_glass <[endLoc].below[0.5]> offset:0.25,0.05,0.25 quantity:35
        - definemap brightness:
            block: 15
            sky: 15
        - spawn item_display[item=lime_stained_glass_pane[custom_model_data=101];scale=1.5,1,1.5;brightness=<[brightness]>] <[endLoc]> save:pud
        - look <entry[pud].spawned_entity> yaw:0 pitch:0
        - define ents <[endLoc].find_entities[living].within[2].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - wait 1s
        - define ents <[endLoc].find_entities[living].within[2].exclude[<player>]>
        - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
        - wait 0.9s
        - remove <entry[pud].spawned_entity>