:: https://www.lawofone.info/images/
::
:: This is an implementation of the Tarot as given by Ra in the Law of One.
::
:: The generator will draw a random card when called without any arguments.
:: Get details for an exact archetype by providing the optional =a or =name...
:: The former must be a @ud of 1-22 or match by exact case-insensitive name.
:: The latter name takes precedence if both are provided; could become error.
:: Getting several cards is also a planned feature that will help with search.
:: So far we only get other cards that are related to the current chosen one.
::
!.
:-  %say
|=  [[now=@da eny=@uvJ *] ~ [o=@tas a=@ud name=tape ~]]
:-  %noun
::
=<
^-  (list item)
=?  o  =(o *@tas)  %upon :: the default output option
=/  n=@ud  (name-to-an name) :: =name takes precedence over =a
=?  a  ?!(=(n 0))  n :: use a if n does not match any %name
=/  r=?   =(0 a)  :: is it random?
::
:: here we set the archetype to focus on, which is one less than the actual n
:: this is done so because list indexing starts at 0
:: also for easier calculations further down...
=/  i=@ud
  ?:  r
    random :: draws a random archetype
  (to-i (valid a))
::
=/  pick=(list item)
  :: the conditions to pick one, so that the work in not in vain
  ?:  |(=(o %one) =(o %upon) &(=(o %all) ?!(r)))
    (one i n r)
  ~[[%many "All or more than one in focus."]]
::
:: check for given output option
?~  (find [o]~ (lists %o))
  ~|(%o-no-such^o !!)
?+  o  ~|(%o-no-code^o !!)
  ::
  %one
  pick
  ::
  :: a specific one, essentially %all with a focus format,
  :: prefer to %one, therefore the default as far as dojo use
  %upon
  (focus i pick o)
  ::
  %all
  ?.  r
    (focus i pick o)
  :: will show all - 3 per line, rather than a random one
  %-  unify  :-  %all
  ;:  weld
    ~[(weld ~[""] (tapes %complex))]
    ~[(blank-pad ~ 4)]
    (into all-in-three 5 (blank-pad ~["Choice Pairs"] 4))
  ==
==
::
|%
::
:: TODO: I'd like to add a couple of types here:
::  idx = (gulf 0 21) :: this = i
::  num = (gulf 1 22) :: this = n
:: these are subsets of @ud that would make unnecessary the validation arms:
:: valid and iv would be deleted, plus these types would be used as io types
:: for all arms using idx or num, please send feedback about any such thing!
::
+$  item  [@tas tape]
+$  items-map  (map @tas tape)
::
++  unify
  |=  [prep=@tas post=(list (list tape))]
  ^-  (list item)
  =.  post  (align post)
  =|  out=(list item)
  |-
  ?~  post
    out
  %=  $
    out  (snoc out prep^:(weld "| " (fuse i.post) " |"))
    post  t.post
  ==
::
:: a custom join fuses consecutive empty space cols to have no separation
++  fuse
  |=  cols=(list tape)
  ^-  tape
  =|  true=?
  =|  last=tape
  =/  done=tape  (head cols)
  |-
  :: we need to be one step ahead in order to compare last to the next one
  =.  last  (head cols)
  =.  cols  (tail cols)
  ?~  cols
    done
  :: do we fuse or separate: true is for fuse
  =.  true  ?|((is-blank last) (is-blank i.cols))
  %=  $
    done  :(weld done ?:(true "   " " | ") i.cols)
  ==
::
:: a tape of either ~ or all-empty spaces is blank
++  is-blank
  |=  this=tape
  ^-  ?
  =|  true=?
  |-
  ?~  this
    true
  ?.  =(' ' i.this)
    %.n
  $(this t.this)
::
:: append spaces to each tape so that the next ones will align for each column
++  align
  |=  rows=(list (list tape))
  ^+  rows
  :: run the loop twice: estimate what widths need to have for each column =
  :: before "doit" we need to aggregate-"have" the maximum length for each
  =/  doit=?  %.n :: we do it the second time around using the same constructs
  =/  have=(list @ud)  ~[0 0 0 0] :: TODO: make this variable (maximum columns)
  :: when doit
  =|  next=(list tape) :: the current next step row, will append to done...
  =|  done=(list (list tape)) :: this is the result, with all tapes aligned
  :: these are looping variables
  =|  wrap=? :: a step completed
  =|  here=@ud :: where within a step we are at any given time (the index)
  =/  step  (head rows)
  =/  walk  (tail rows)
  ::
  |-
  :: modify the subject variables
  =?  have  ?!  doit
    :: on a second pass that's already done
    :: calculate the max lent for each column's tape
    (snap have here (max (snag here have) (lent (head step))))
  =?  next  doit
    :: first time around we don't know how to do it
    :: append spaces based on have of each tape for each row = max col lent
    =/  need=@ud  (snag here have) :: the length we need
    =/  miss=@ud  (sub need (lent (head step))) :: in order to satisfy a need
    (snoc next (weld (head step) (reap miss ' '))) :: append for left-aligned
  =.  wrap  ?!  (lte here (lent step))
  =?  done  doit :: first time around we don't know how to do it
    ?.  wrap  done  (snoc done next)
  ::
  :: recur or return
  ?.  wrap
    $(here +(here), step (tail step))
  ?.  =(~ walk)
    $(here 0, step (head walk), walk (tail walk), next ~)
  ?.  doit
    $(here 0, step (head rows), walk (tail rows), doit %.y)
  done
::
:: focus is on one and the meta-learning that is related to a pick
++  one
  |=  [i=@ud n=@ud r=?]
  ^-  (list item)
  ::  put the output gogether -- various items in a list
  ::  welp is more permissive for mixing types than weld, and it does the same
  ::  such as excluding stuff with ~ and later have those not show by ^- cast
  ;:  welp
    ~[(get-item i %name)]
    :: show the archetype number when selected via =name (presume not known)
    :: also when a number is drawn at random  -the second part of the | or
    ?:  |(?!(=(0 n)) r)  ~[[%number (scow %ud (to-n i))]]  ~
    ?.  r
      ~  :: not random - a specific archetype asked for
    :~
      :: show these two only when random i for no a given, nor name given
      :: here we output the now moment because it could be used for
      :: further astrological analysis ...
      :: TODO: make readable - perhaps split into date and time?
      [%when (scow %da now)]
    ==
    ~[(get-item (class i) %class)]
    ~[%complex^(complex i)]
    (get-three i)
    (get-other i)
  ==
::
++  map-items
  |=  items=(list item)
  ^-  items-map
  :: (my items) would be ideal here, yet it did not work...
  :: in fact this exists for that reason
  =|  the=items-map
  |-
  ?~  items
    the
  $(the (~(put by the) (head i.items) (tail i.items)), items t.items)
::
++  focus
  |=  [i=@ud pick=(list item) opt=@tas]
  =<
  ^-  (list item)
  :: put all of this together with a call to unify:
  %-  unify  :-  opt
  :~
    (weld ~["= Archetype"] complex-top)
    (blank-pad ~ 4)
    ?:(paired-next number-row paired-row)
    %-  weld
      :-  ~[(weld (get hand %class) " >")]
      ?:  the-choice
        (reap 3 (weld "= " (get-tape (to-i 22) %name)))
      :~
        (get hand %mind)
        (get hand %body)
        (get hand %spirit)
      ==
    ?:(paired-next paired-row number-row)
    ::  TODO: add ability for one column to overflow into the next one
    ::  by adding of an extra row preceding the one to be processed so:
    :: (blank-pad ~ 4)
    ::  ~["FORMAT:" "*" "" ">" ""] :: here col 3 overflows into col 4
    ::  TODO: perhaps also validate cols 3 and 4 using is-blank
    :: :(weld ~["Time Reason -"] ~[""] ~[(scow %da now)] ~[""])
  ==
  ::
  :: prepare what the subject needs so that the code above can run
  :: because the code below is heavier and also for better readability
  ::
  :: getting an error when using my:nl thus I wrote an arm for making a map
  =/  hand=items-map  (map-items pick)
  =/  the-choice=?  =((to-n i) 22)
  =/  complex-id=@tas  (tape-to-tas (complex i))
  =?  hand  ?!(the-choice)
    :: the archetyte that's in focus gets "= " so that it stands out
    (~(put by hand) complex-id (weld "= " (get hand complex-id)))
  :: make each of the complex headers vertically align with the content below
  =/  complex-top=(list tape)  (tapes %complex)
  =.  complex-top  %-  snap
    :*
      complex-top
      (tail (find [(get hand %complex)]~ complex-top))
      (weld "@ " (get hand %complex))
    ==
  =?  complex-top  the-choice
    (turn complex-top |=(this=tape (weld "@ " this)))
  ::
  =/  number-idx=@ud  ?:  the-choice  0  +((three i))
  =/  number-row=(list tape)  %-  blank-pad  :-
      (weld (blank-pad ~ number-idx) ~[(weld "# " (scow %ud (to-n i)))])
    4
  ::
  =/  paired-i=@ud  (tail (find [(get hand %pair)]~ (tapes %name)))
  =/  paired-class=tape  (get-tape (class paired-i) %class)
  =/  paired-row=(list tape)
    ?:  the-choice
      %-  blank-pad  :-
        :~
          paired-class
          (weld ": " (get-tape 4 %name))
          (weld ": " (get-tape 11 %name))
          (weld ": " (get-tape 18 %name))
        ==
      4
    %-  blank-pad  :-
      %-  weld  :-
        (blank-pad ~[paired-class] number-idx)
      ~[(weld ": " (get hand %pair))]
    4
  :: does the paired archetype follow next (i.e. below) the current one?
  =/  paired-next=?  (lth i paired-i)
  :: this subject is ready for work - look at the arm's top for how it's used
  .
::
:: easy value, given a map and a key, so I can make calls with less code
++  get
  |=  [a-map=items-map a-key=@tas]
  ^-  tape
  (~(got by a-map) a-key)
::
:: name-to-an (further work)...
:: TODO: this function will ideally have to do partial matches with substring
:: for the time being until multiple matches are supported ...
:: just throw exception if more than one is mathed
:: also add a function that does the matching that could be more elegant
:: consider how this can be upgraded or repurposed to also match %class...
::
:: returns an n so that non-matching can be 0 / handled on the calling end
++  name-to-an  :: an is alluding to n overriding a, as it takes extra effort
                :: an also goes well with archetype + both a & n represent it
  |=  the=tape
  ^-  @ud
  =|  n=@ud
  =/  found=?  %.n
  =/  names=(list tape)  (tapes %name)
  |-
  ?:  found
    n
  ?~  names
    0
  $(found =((cass the) (cass i.names)), n +(n), names t.names)
::
:: archetypes 1-22 > for @ud io that's human-reasonable
:: this is mostly for validating the a input as name-to-an > 0 has to be valid
++  valid
  |=  the=@ud
  ^-  @ud
  ?:  (lth the 1)
    :: this should not happen as 0 is used to ask for a random archetype
    ~|(%archetype-none^0 !!)
  ?:  (gth the 22)
    ~|(%archetype-beyond-22^the !!)
  the
::
:: validates i without going through n as a convenience
++  iv
  |=  i=@ud  ^-  @ud
  (to-i (valid (to-n i)))
::
:: assumes converting from i
++  to-n
  |=  in=@ud  ^-  @ud
  (valid +(in))
::
:: assumes converting from n
++  to-i
  |=  on=@ud  ^-  @ud
  (sub (valid on) 1)
::
:: 0-21 as a practical 1-22
++  random
  ^-  @ud
  =/  rng  ~(. og eny)
  (rad:rng 21)
::
:: mind-boby-spirit-choice is 0-3 derived from 1-21
:: 21 corresponds to archetype #22 which covers all three matrices / complexes
:: it is the only one reaching 3 (w/r-to The Choice being in a class of its own)
++  three
  |=  i=@ud
  ^-  @ud
  (div i 7)
::
++  class
  |=  i=@ud  ^-  @ud
  =/  t=@ud  (three i)
  ?:  =(3 t)
    7
  (mod i 7)
::
++  get-tape
  |=  [i=@ud id=@tas]
  ^-  tape
  (snag i (tapes id))
::
++  get-item
  |=  [i=@ud id=@tas]
  ^-  item
  id^(get-tape i id)
::
++  complex
  |=  i=@ud
  ^-  tape
  (get-tape (three i) %complex)
::
::  archetype triple of: %mind %body %spirit (complex) per class
++  get-three
  |=  i=@ud
  ^-  (list item)
  %-  turn  :-
    ~[0 1 2]
  |=  a=@ud
  ^-  item
  =/  id  ?.(=(i (to-i 22)) (add (class i) (mul a 7)) i)
  (snag a (lists %complex))^(get-tape id %name)
::
::  archetype pair from the reference link at the top
++  get-other
  |=  i=@ud
  ^-  (list item)
  =/  the  21 :: i of 21 is archetype #22 (the %choice)
  =/  key  %pair
  =/  row  (class i)
  ?:  =(i the)
    ::
    :: pairs with all of row 4 Significator archetypes
    :: TODO: make this appear more DSL-like than hardcoded...
    :: although it's a special case - these are just what get-three produces,
    :: only with the head changed to %pair (same for all three)
    :~
      key^(get-tape 4 %name)
      key^(get-tape 11 %name)
      key^(get-tape 18 %name)
    ==
  :-  :-  key
    ?:  =(row 4)
      :: a %significator archetype is paired with the %choice
      (get-tape the %name)
    ?:  |(=(row 1) =(row 3) =(row 6))
      :: rows 1 / 3 / 6 paired with a previous archetype
      (get-tape (sub i 1) %name)
    :: rows 0 / 2 / 5 paired with a next archetype
    (get-tape +(i) %name)
  ~
::
:: wrong idea for this one, as it's getting 3 at a time from the wrong list
:: instead of making a new list from (tapes %name), it would be easier to...
:: start from scratch and leave this one here because of its TODO: question
++  all-no-three
  ^-  (list (list tape))
  =/  names=(list tape)  (tapes %name)
  =/  final=tape  (snag (sub (lent names) 1) names)
  =|  front=@ud
  =|  ready=(list (list tape))
  =.  names  (oust [(sub (lent names) 1) 1] names)
  |-
  :: TODO: the following don't work in the $() - why?
  =.  ready  (snoc ready (weld ~[""] (scag 3 names)))
  =.  names  (slag 3 names)
  ?~  names
    ready
  $(front +(front))
::
++  all-in-three
  ^-  (list (list tape))
  =/  front=@ud  (sub 21 7)
  =/  count=@ud  22
  =|  the=items-map
  =|  these=(list tape)
  =|  ready=(list (list tape))
  |-
  =.  the  (map-items (get-three front))
  =.  these  ~[(get the %mind) (get the %body) (get the %spirit)]
  =.  these  (into these 0 (get-tape (class front) %class))
  :: NOTE: fewer that 3 per row will break the code at the moment: why?
  =?  these  =(front 21)  (blank-pad (scag 2 these) 4) :: special case
  ?.  (lth front count)
    ready
  %=  $
    front  +(front)
    ready  (snoc ready these)
  ==
::
:: TODO: turn this into a bunt-pad (or refactor it to call bunt-pad)
:: using bunted values, inferred from (list) of anything
:: simply use the type of the head (if list not ~)
:: though the list cannot be empty (do not know if that matters)
:: can otherwise pass the type for bunt as a third arg (try that first)
++  blank-pad
  |=  [start=(list tape) reach=@ud]
  ^+  start
  ?:  =((lent start) reach)
    start
  ?:  (lth (lent start) reach)
    (weld start (reap (sub reach (lent start)) *tape))
  ~|(%already-beyond-reach^start^reach !!)
::
++  lists
  |=  what=@tas
  ^-  (list @tas)
  ?+  what  ~|(%lists-none-such^what !!)
    %complex  (tapes-to-tas-list (tapes what))
    %class    (tapes-to-tas-list (tapes what))
    %name     (tapes-to-tas-list (tapes what))
    ::
    :: %output or %options - the optional =o of this "%say generator"
    :: TODO: make this a map with these keys and values of help tapes?
    %o  :~
      ::
      :: the three primary ways for rendering output are %one, %upon & %all
      :: also, the only options implemented for starters
      ::
      :: data for a single archetype we get via %one, currently (list item)
      :: this could become a map to be more convenient for code use
      %one
      ::
      :: upon is the default for being the most readable
      :: it follows the same structure as %all, except
      :: everything is focused upon a single archetype (requested or random)
      :: in this sense the content is basically identical to the %one above
      %upon
      ::
      :: show %all the archetypes, three per row, as introduced by Ra
      :: using a tabular list of vertically aligned tapes in 4 rows
      :: as well as headings for %class, %mind, %body and %spirit
      :: %all will apply to the context of a requested =a or =name
      :: that results in output identical to %upon - look above
      %all
      ::
      :: NOTE: none of the following have been implmented yet
      :: also, they aren't necessary, and similar effects could be achieved
      :: with a future landscape app that would also be a better ux
      ::
      :: will focus on a specific key, or %mind %body %spirit triple keys
      :: meant only when there is a single matching archetype or a random one
      %pair
      %class
      %three
      ::
      :: the rest will return multiple archetypes; %all also applies here
      %list         :: lists all 22 archetypes in sequential order
      %pairs        :: 12 unique pairs - see link at the top
      %mind         :: list of 7/8: the %choice is shown last, or skipped?
      %body         :: list of 7/8: the %choice is shown last, or skipped?
      %spirit       :: list of 7/8: the %choice is shown last, or skipped?
      :: TODO: consider switching to list of options, e.g. ~[%mind %pairs]
      %mind-pairs   :: list of 4 %mind %pairs
      %body-pairs   :: list of 4 %body %pairs
      %spirit-pairs :: list of 4 %spirit %pairs
    ==
  ==
::
++  tapes-to-tas-list
  |=  tapes=(list tape)
  ^-  (list @tas)
  %-  turn
  :-  tapes
  |=(item=tape (tape-to-tas item))
::
:: probably incomplete though better than necessary tape to @tas converter
:: lowercase; replace spaces with '-' + handle leading and trailing spaces
:: assumes no special characters used - which could be handled some day...
:: perhaps all that is missing is restrict input to letters and numbers...
:: together with extra logic to handle pre-existing dashes?
++  tape-to-tas
  |=  a=tape
  ^-  @tas
  =.  a  (cass a)
  ?~  (find " " a)
    (crip a)
  :: s is for index of spaces in a tape
  =/  s  (fand " " a)
  :: p is for the last space index position
  =/  p  (head s)
  %-  crip
  |-
  ?~  s
    :: any consecutive spaces remain - skipping them here
    =.  a  (skip a |=(c=@t =(c ' ')))
    :: trailing spaces would produce a trailing -
    ?:  =(0 (head (fand "-" (flop (weld "-" a)))))
      :: get rid of a trailing -
      (scag (sub (lent a) 1) a)
    a
  :: in case of consecutive spaces, only the first one is turned to -
  :: I wanted to use '' instead of ' ' (replacing in reverse to preserve indexes)
  :: but that ended up inserting \00 ... (so have to remove spaces later)
  %=  $
    a  (snap a i.s ?:(|(=(i.s 0) =(i.s +(p))) ' ' '-'))
    p  i.s
    s  t.s
  ==
::
::  Lists of tapes: here I'm switching to lists of tapes (from the lists above)
::  as it is easier to convert from a tape to a @tas than vice versa
++  tapes
  |=  what=@tas
  ^-  (list tape)
  ?+  what  ~|(%tapes-none-such^what !!)
  %complex
    ~["Mind" "Body" "Spirit" "Mind-Body-Spirit"]
  %class
    :~
      "Matrix"
      "Potentiator"
      "Catalyst"
      "Experience"
      "Significator"
      "Transformation"
      "Great Way"
      "The Choice"
    ==
  %name
    :~
      "Magician"
      "High Priestess"
      "Empress"
      "Emperor"
      "Hierophant"
      "Lovers"
      "Chariot"
      "Strength"
      "Hermit"
      "Wheel of Fortune"
      "Justice"
      "Hanged Man"
      "Death"
      "Temperance"
      "Devil"
      "Tower"
      "Star"
      "Moon"
      "Sun"
      "Judgement"
      "World"
      "Choice"
    ==
  ==
--
