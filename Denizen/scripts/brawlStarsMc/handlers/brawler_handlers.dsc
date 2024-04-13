

brawlers_handler:
    type: world
    debug: false
    events:
        on player damaged:
            - determine passively cancelled
            - define player1 <context.entity>
            - flag <player> bs.combatTag expire:3s
            - if <[player1].has_flag[bs.decay_shield]>:
                - define data <[player1].flag[bs.decay_shield]>
                - definemap shielddata:
                    tothealth: <[data.tothealth]>
                    health: <[data.health].sub[<context.damage.round_down>].round_down>
                    text: <[data.text]>
                    shield: <[data.shield]>
                - if <[shielddata.health]> <= 0:
                    - remove <[shielddata.shield]>
                    - remove <[shielddata.text]>
                    - flag <[player1]> bs.decay_shield:!
                    - stop
                - adjust <[shielddata.text]> text:<[shielddata.health]>
                - flag <[player1]> bs.decay_shield:<[shielddata]>
                - stop
            - animate animation:hurt for:<[player1]>
            - flag <[player1]> bs.hp:-:<context.damage.round_down>
        on player right clicks block with:item_flagged:atk:
            - ratelimit <player> 5t
            - flag <player> bs.combatTag expire:3s
            - stop if:<player.has_flag[bs.shotDelay]>
            - if <player.flag[bs.ammo]> > 0:
                - flag <player> bs.ammo:-:1
                - actionbar "<&b><&l><player.flag[bs.character].to_titlecase> <&f>| <&c><player.flag[bs.hp]>/<player.flag[bs.mhp]> <&f>| <&7>Ammo: <&8><player.flag[bs.ammo]>/<player.flag[bs.maxAmmo]>"
                - run <context.item.flag[atk]>
            - else:
                - actionbar "<&b><&l><player.flag[bs.character].to_titlecase> <&f>| <&c><player.flag[bs.hp]>/<player.flag[bs.mhp]> <&f>| <&7>Ammo: <&8><player.flag[bs.ammo]>/<player.flag[bs.maxAmmo]>"
                - playsound sound:block_note_block_bass <player> volume:0.5
                - playsound sound:block_lever_click <player> volume:1 pitch:0.7
        on tick every:5:
            - foreach <server.online_players_flagged[bs.hp]> as:__player:
                - foreach next if:<player.has_flag[bs.character].not>
                - inject <player.flag[bs.character]>
                - foreach next if:<player.has_flag[bs.combatTag]>
                # If the Brawler does not attack or take damage for 3 seconds, its health will start to regenerate over time by 13% of their maximum health. The second bar has ...
                - flag <player> bs.hspeed:+:1
                - if <player.flag[bs.hspeed]> >= 4:
                    - flag <player> bs.hp:+:<player.flag[bs.hp].mul[0.13].round_down>
                    - flag <player> bs.hspeed:!
                - if <player.flag[bs.hp]> >= <[data.health]>:
                    - flag <player> bs.hp:<[data.health]>

            - foreach <server.online_players_flagged[bs.ammo]> as:__player:
                - foreach next if:<player.has_flag[bs.character].not>
                - inject <player.flag[bs.character]>
                - if <player.flag[bs.ammo]> < <[data.ammo]> && <player.has_flag[bs.shotDelay].not>:
                    - flag <player> bs.rspeed:+:0.2
                    - if <player.flag[bs.rspeed]> >= <[data.reloadSpeed]>:
                            - flag <player> bs.rspeed:!
                            - if <player.flag[bs.ammo]> >= <player.flag[bs.maxAmmo]>:
                                - flag <player> bs.ammo:<player.flag[bs.maxAmmo]>
                            - else:
                                - flag <player> bs.ammo:+:1
                - actionbar "<&b><&l><player.flag[bs.character].to_titlecase> <&f>| <&c><player.flag[bs.hp]>/<player.flag[bs.mhp]> <&f>| <&7>Ammo: <&8><player.flag[bs.ammo]>/<player.flag[bs.maxAmmo]>"
        on tick every:10:
            # decay shields
            - foreach <server.online_players_flagged[bs.decay_shield]> as:__player:
                - define data <player.flag[bs.decay_shield]>
                - definemap shielddata:
                    tothealth: <[data.tothealth]>
                    health: <[data.health].sub[<[data.tothealth].mul[0.05]>].round_down>
                    text: <[data.text]>
                    shield: <[data.shield]>
                - if <[shielddata.health].if_null[0]> <= 0:
                    - remove <[shielddata.shield]>
                    - remove <[shielddata.text]>
                    - flag <player> bs.decay_shield:!
                    - stop
                - adjust <[shielddata.text]> text:<[shielddata.health]>
                - flag <player> bs.decay_shield:<[shielddata]>
        on player holds item item:brawler_ultimate_key:
            - determine cancelled if:<player.inventory.slot[<context.new_slot>].custom_model_data.is_less_than[9100]>
            - wait 1t
            # - while <player.item_in_hand.script.name.equals[brawler_ultimate_key].if_null[false]>:
            #     - define circle <player.location.points_around_y[radius=1;points=5]>
            #     - playeffect effect:redstone special_data:0.3|#93b2fa at:<[circle]> offset:0.1,0,0.1 quantity:10 targets:<player>
            #     - playeffect effect:redstone special_data:0.3|#ffff00 at:<[circle]> offset:0.1,0,0.1 quantity:10 targets:<server.online_players.exclude[<player>]>
            #     - wait 1t
        on player right clicks block with:item_flagged:link:
            - determine passively cancelled
            - flag <player> bs.superCharge:0
            - adjust <player> item_slot:1
            - inventory adjust slot:2 custom_model_data:9<player.flag[bs.superCharge].round_down>
            - run <context.item.flag[link]>
        on player damages entity:
            - define player <context.damager>
            - inject <[player].flag[bs.character]>
            - if <[player].flag[bs.superCharge]> >= 100:
                - flag <[player]> bs.superCharge:100
            - if <context.cause> == ENTITY_SWEEP_ATTACK:
                - flag <[player]> bs.superCharge:+:<[data.ult_ult_charge]>
            - else if <context.cause> == ENTITY_EXPLOSION:
                - inject gus.gus_bar
                - if <[player].flag[bs.superCharge]> >= 100:
                    - flag <[player]> bs.superCharge:100
                    - stop
                - flag <[player]> bs.superCharge:+:<[data.atk_ult_charge]>
            - else if <context.cause> == ENTITY_ATTACK:
                - determine passively cancelled
            - if <[player].flag[bs.superCharge]> >= 100:
                - flag <[player]> bs.superCharge:100
            - inventory adjust slot:2 custom_model_data:9<player.flag[bs.superCharge].round_down>
        on entity damaged:
            - adjust <context.entity> max_no_damage_duration:0t
            - adjust <context.entity> no_damage_duration:0t

ultbar_charge_test:
    type: task
    debug: false
    script:
        - repeat 100:
            - inventory adjust slot:2 custom_model_data:9<[value]>
            - wait 1t

brawler_ultimate_key:
    type: item
    debug: false
    material: yellow_stained_glass_pane
    mechanisms:
        custom_model_data: 900

brawler_damage_task:
    type: task
    debug: false
    definitions: data|ents
    script:
        - define dmg


brawler_select:
    type: task
    debug: false
    definitions: brawler
    script:
        - flag <player> bs.thrower:!
        - flag <player> bs:!
        - inject <[brawler]>
        - adjust <player> speed:<[data.speed].proc[speedCalc]>
        - flag <player> bs.character:<[brawler]>
        - flag <player> bs.hp:<[data.health]>
        - flag <player> bs.mhp:<[data.health]>
        - flag <player> bs.ammo:<[data.ammo]>
        - flag <player> bs.maxAmmo:<[data.ammo]>
        - flag <player> bs.superCharge:0
        - inventory set o:<[data.atk]> slot:1
        - if <player.has_flag[bs.thrower]>:
            - inventory set o:<item[brawler_ultimate_key].with_flag[link:<[data.ult]>].with_flag[thrower:true].with[display=<[data.ult_name]>]> slot:2
        - else:
            - inventory set o:<item[brawler_ultimate_key].with_flag[link:<[data.ult]>].with[display=<[data.ult_name]>]> slot:2

        - foreach <player.bossbar_ids> as:id:
            - bossbar remove <[id]>

brawlerSelectMenu:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <script.parsed_key[data.title].unseparated>
    data:
        title:
        - <&f><static[<proc[negative_spacing].context[8].font[spaces]>]>
        - <&chr[E004].font[guis]>
    definitions:
        p: pane_black
    size: 54
    slots:
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
