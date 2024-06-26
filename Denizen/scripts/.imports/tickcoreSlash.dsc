# @ ----------------------------------------------------------
# TickCore Slash!
# A script that uses trigonometry to generate slash points,
# which when connected, create a slash effect.
# Author: 0TickPulse
# @ ----------------------------------------------------------

slash_util_ring_proc:
    type: procedure
    debug: false
    definitions: radius|points
    script:
    - define list <list>
    - define angles <list>
    - define i 0
    - define angle_interval <element[360].div[<[points]>]>
    - while <[i]> < 360:
        - define i:+:<[angle_interval]>
        - define angles:->:<[i]>

    - foreach <[angles]> as:angle:
        - definemap offsets:
                forward: <[radius].mul[<[angle].to_radians.cos>]>
                right: <[radius].mul[<[angle].to_radians.sin>]>
        - define list:->:<[offsets]>

    - determine <[list]>

circg:
    type: procedure
    debug: false
    definitions: data
    script:
    - foreach location|radius|rotation|points|arc as:def:
        - define <[def]> <[data.<[def]>]>
    - if <[rotation]> < 0:
        - define rotation:+:180
    - define list <list>
    # The starting angle
    - define i <[arc].div[-2].add[90]>
    # <[arc].div[2].add[90]> is the ending angle
    - while <[i]> <= <[arc].div[2].add[90]>:
        - define relative_horizontal_offset <[radius].mul[<[arc].div[2].sub[<[i]>].to_radians.sin>]>
        - define horizontal_offset <[relative_horizontal_offset].mul[<[rotation].to_radians.cos>]>
        - define forward_offset <[radius].mul[<[arc].div[2].sub[<[i]>].to_radians.cos>]>
        - define vertical_offset <[rotation].to_radians.sin.mul[<[relative_horizontal_offset]>]>
        - define list:->:<[location].forward[<[forward_offset]>].right[<[horizontal_offset]>].up[<[vertical_offset]>]>
        # Adds the angle interval
        - define i:+:<[arc].div[<[points]>]>
    - determine <[list]>

circe:
    type: procedure
    debug: false
    definitions: data
    script:
    - define locations <[data].proc[circg]>
    - define entities <list>
    - foreach <[locations]> as:location:
        - define entities:|:<[location].points_between[<player.location>].distance[0.2].parse_tag[<[parse_value].find.living_entities.within[1]>].combine>
    - determine <[entities].deduplicate>