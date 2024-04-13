bs_shelly_buckshot:
    type: item
    display name: <&f>Buckshot
    material: stone_axe
    mechanisms:
        hides: all
        custom_model_data: 100
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 20
                    slot: hand
        unbreakable: true
    flags:
        atk: shelly.atk

shelly:
    type: task
    debug: false
    script:
        - definemap data:
            health: 3700
            health_scale: 370
            speed: 770
            ammo: 3
            reloadSpeed: 1.5
            rarity: common

            charDesc: "Shelly's the perfect ranger: reliable, tough, and terrific with her shotgun. She never understood why Colt got to steal the limelight..."

            atk: bs_shelly_buckshot
            atkRange: 7.67
            atk_base: 300
            atk_ult_charge: 10.05
            atk_scale: 30

            ult: shelly.ult
            ult_name: Super Shell
            ultRange: 7.67
            ult_ult_charge: 4.838
            ult_base: 320
            ult_scale: 32
    atk:
        - flag <player> bs.shotDelay expire:10s
        - inject shelly
        # - ratelimit <player> 0.5s
        - define loc <player.eye_location.below[0.5].with_pitch[0]>
        - definemap arc:
            location: <[loc].forward_flat[<[data.atkRange]>]>
            radius: 3
            rotation: 0
            points: 5
            arc: 180
        - define arc <[arc].proc[circg].reverse>
        - playsound sound:entity_generic_explode <player> volume:0.4 pitch:2
        - foreach <[arc]> as:p:
            - define shotPath <[loc].points_between[<[p]>].distance[0.2]>
            - run shelly_atkProjSpread def:<list_single[<[shotPath]>]> def.speed:3
        - wait 5t
        - flag <player> bs.shotDelay:!
    ult:
        - inject shelly
        - define loc <player.eye_location.below[0.5].with_pitch[0]>
        - playsound sound:entity_generic_explode <player> volume:0.4 pitch:0.7
        - definemap arc:
            location: <[loc].forward_flat[<[data.ultRange]>]>
            radius: 5
            rotation: 0
            points: 9
            arc: 180
        - define arc <[arc].proc[circg].reverse>
        - foreach <[arc]> as:p:
            - define shotPath <[loc].points_between[<[p]>].distance[0.2]>
            - run shelly_atkProjSpreadSuper def:<list_single[<[shotPath]>]> def.speed:4
        - wait 5t

shelly_atkProjSpreadSuper:
    type: task
    debug: false
    definitions: path|speed
    script:
        - inject shelly
        - foreach <[path]> as:p:
            - playeffect effect:redstone special_data:0.3|#64c0f5 offset:0.1 quantity:15 at:<[p]> visibility:1000000
            - define ents <[p].find_entities[living].within[0.1].exclude[<player>]>
            - hurt <[data.ult_base]> <[ents]> source:<player> cause:ENTITY_SWEEP_ATTACK
            - modifyblock air <[p].find_blocks.within[1]>
            - if <[loop_index].mod[<[speed]>]> == 0:
                - wait 1t
shelly_atkProjSpread:
    type: task
    debug: false
    definitions: path|speed
    script:
        - inject shelly
        - foreach <[path]> as:p:
            - playeffect effect:redstone special_data:0.2|#64c0f5 offset:0.1 quantity:15 at:<[p]> visibility:1000000
            - define ents <[p].find_entities[living].within[0.1].exclude[<player>]>
            - hurt <[data.atk_base]> <[ents]> source:<player> cause:ENTITY_EXPLOSION
            - foreach stop if:<[ents].any>
            - if <[loop_index].mod[<[speed]>]> == 0:
                - wait 1t