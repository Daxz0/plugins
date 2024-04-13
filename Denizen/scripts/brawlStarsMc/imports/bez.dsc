bezier_arc:
  type: procedure
  debug: false
  definitions: start_point|end_point|control_y|resolution
  script:
  - define start_point_up <[start_point].above>
  - define start <[start_point_up].above[1].sub[<[start_point_up]>]>
  - define end_point <[end_point].sub[<[start_point_up]>].above[2]>
  - define control <[end_point].div[2].with_y[<[end_point].y.add[<[control_y]>]>]>

  - repeat <[resolution]> as:i:
    - define t <[i].div[<[resolution]>]>
    - define u <element[1].sub[<[t]>]>
    - define tt <[t].mul[<[t]>]>
    - define uu <[u].mul[<[u]>]>
    - define uua <[start].mul[<[uu]>]>
    - define uuc <[control].mul[<[u]>].mul[2].mul[<[t]>]>
    - define tte <[end_point].mul[<[tt]>]>
    - define points:->:<quaternion[identity].transform[<[uua].add[<[uuc]>].add[<[tte]>]>]>
  - determine <[points].parse_tag[<[start_point].add[<[parse_value]>]>]>