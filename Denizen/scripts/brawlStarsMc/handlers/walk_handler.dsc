walk_handler:
    type: world
    debug: false
    events:
        on player steps on block flagged:!bs.bushes:
            - define locy <player.location.above[1]>
            - if <[locy].material.name> == tall_grass:
                - flag <player> bs.bushes expire:1d
                - adjust <player> hide_from_players:<server.online_players>
            # - if <[locy].material.name> == dead_brain_coral:
        on player steps on block flagged:bs.bushes:
            - define locy <player.location.with_pitch[90].ray_trace[range=15].above[1]>
            - define ent <player>
            - if <player.has_flag[bs.thrower_active]>:
                - define ent <player.flag[bs.thrower_active.npc].if_null[<player>]>

            - if <[locy].material.name> != tall_grass:
                - adjust <[ent]> show_to_players:<server.online_players>
            - else if <[locy].material.name> == tall_grass:
                - define ents <[ent].location.find_players_within[2]>
                - if <[ents].any>:
                    - adjust <[ent]> show_to_players:<[ents]>
                    - foreach <[ents]> as:e:
                        - adjust <[e]> show_to_players:<[ent]>


