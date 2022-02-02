- i = 1
- bal = 0.0
table.small-table.sortable
  tr
    th #
    th 
      i.fas.fa-sort.noprint
      | Player
    th 
      i.fas.fa-sort.noprint.numeric
      | Rnds
    th 
      i.fas.fa-sort.noprint.numeric
      | Won
    th
      i.fas.fa-sort.noprint.numeric
      | Dues
    th 
      i.fas.fa-sort.noprint.numeric
      | Bal
    th
      i.fas.fa-sort.noprint.numeric
      | PTRank
    th
      i.fas.fa-sort.noprint.numeric
      | Avg
  - money_list.each do |a|
    -if a[1] > 2
      tr
        td=i
        td= a[0]
        td.text-right=a[1]
        td.text-right=to_nickels a[2],true
        td.text-right=a[3]
        td.text-right=to_nickels a[4],true
        td.text-right=sprintf( "%0.03f", a[5])
        td.text-right=sprintf( "%0.03f", a[6])
      - bal += a[4]
      - i+=1
p = "Balance: #{to_nickels bal,true}"
