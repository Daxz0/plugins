thrower_handler:
    type: world
    debug: false
    events:
        on player left clicks block with:item_flagged:thrower:
            # - determine passively cancelled
            - if <player.has_flag[bs.thrower_active]>:
                - teleport <player> <player.flag[bs.thrower_active.npc].location>
                - remove <player.flag[bs.thrower_active.cam]>
                - remove <player.flag[bs.thrower_active.npc]>
                - cast invisibility remove
                - flag <player> bs.thrower_active:!
                - stop
            - flag <player> bs.thrower_active
            - create player <player.name> <player.location> save:npc
            - define npc <entry[npc].created_npc>
            - define dist 1
            - cast invisibility <player> d:-1t hide_particles no_icon
            - spawn armor_stand[gravity=false;visible=false] <[npc].location.above[0.5].backward[<[dist]>]> save:cam
            - define cam <entry[cam].spawned_entity>

            - mount <player>|<[cam]>
            - equip <[npc]> hand:<player.item_in_hand>
            - flag <player> bs.thrower_active.npc:<[npc]>
            - flag <player> bs.thrower_active.cam:<[cam]>
            - run <player.flag[bs.character]>.visualize
            - while <player.has_flag[bs.thrower_active]>:
                - define beam <player.eye_location.points_between[<player.eye_location.backward_flat[<[dist]>]>].distance[0.5].reverse>
                - foreach <[beam]> as:point:
                    - if <[point].material.name> == air:
                        - define hit <[point].distance[<player.eye_location>]>
                        - foreach stop
                    - else:
                        - define hit -0.3
                - define locy <[npc].location.above[3].backward[<[hit]>]>
                - teleport <[cam]> <[locy]>
                - look <[npc]> yaw:<player.location.yaw> pitch:0
                - wait 1t
            - if <player.has_flag[bs.thrower_active]>:
                - teleport <player> <player.flag[bs.shield.npc].location>
                - remove <player.flag[bs.thrower_active.cam]>
                - cast invisibility remove
                - mount <player> cancel
                - flag <player> bs.thrower_active:!
                - cast invisibility remove
        on player steers entity flagged:bs.thrower_active:
            - if <context.dismount>:
                - determine cancelled
            - define forward <context.forward>
            - define side <context.sideways.div[5]>
            - define up <context.jump>
            - define stand <player.flag[bs.thrower_active.npc]>
            - define location <[stand].location.with_pitch[<[stand].location.pitch>].forward[<[forward].div[4]>].with_y[<[stand].location.y>]>

            - if <[side]> != 0:
                - define side <[side].mul[-1]>
                - define location <[location].right[<[side]>]>
            - define hit <[location].with_y[<[stand].location.y>].above[2].with_pitch[90].ray_trace[range=200]>
            - if <[hit].above[0.1].material.is_solid>:
                - stop
            - teleport <[stand]> <[hit].with_pitch[0].with_yaw[<player.location.yaw>]> relative