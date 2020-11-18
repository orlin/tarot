# Tarot

An implementation of the tarot as given by Ra
in [The Law of One](https://www.lawofone.info).
It's a very basic tool for learning the 22 archetypes of the Major Arcana.

It can draw a card at random, and show all cards related to it.
Since it does give additional detail -
one could ask for a card by name or number.

### [A Tabular Aid](https://www.lawofone.info/images)

There is also an option to show a table of all cards
organized into Mind/Body/Spirit complex columns
and the 8 classification categories for rows.
This format makes the triples and pairs easy to spot
as one learns the material.

What follows is a representation of such an aid,
possibly just a placeholder of a future app screenshot.

|                                          /                                          |                       M i n d                       |                         B o d y                         |                   S p i r i t                    |
| :---------------------------------------------------------------------------------: | :-------------------------------------------------: | :-----------------------------------------------------: | :----------------------------------------------: |
|                                         ...                                         |                       complex                       |                         complex                         |                     complex                      |
|                                                                                     |                                                     |                                                         |                                                  |
|                         **M<br/>a<br/>t<br/>r<br/>i<br/>x**                         |    ![](images/card-1.jpg?raw=true "1. Magician")    |      ![](images/card-8.jpg?raw=true "8. Strength")      |   ![](images/card-15.jpg?raw=true "15. Devil")   |
|                                                                                     |                          :                          |                            :                            |                        :                         |
|          **P<br/>o<br/>t<br/>e<br/>n<br/>t<br/>i<br/>a<br/>t<br/>o<br/>r**          | ![](images/card-2.jpg?raw=true "2. High Priestess") |       ![](images/card-9.jpg?raw=true "9. Hermit")       |   ![](images/card-16.jpg?raw=true "16. Tower")   |
|                                                                                     |                                                     |                                                         |                                                  |
|                                                                                     |                       &mdash;                       |                         &mdash;                         |                     &mdash;                      |
|                                                                                     |                                                     |                                                         |                                                  |
|                   **C<br/>a<br/>t<br/>a<br/>l<br/>y<br/>s<br/>t**                   |    ![](images/card-3.jpg?raw=true "3. Empress")     | ![](images/card-10.jpg?raw=true "10. Wheel of Fortune") |   ![](images/card-17.jpg?raw=true "17. Star")    |
|                                                                                     |                          :                          |                            :                            |                        :                         |
|             **E<br/>x<br/>p<br/>e<br/>r<br/>i<br/>e<br/>n<br/>c<br/>e**             |    ![](images/card-4.jpg?raw=true "4. Emperor")     |     ![](images/card-11.jpg?raw=true "11. Justice")      |   ![](images/card-18.jpg?raw=true "18. Moon")    |
|                                                                                     |                                                     |                                                         |                                                  |
|                                                                                     |                       &mdash;                       |                         &mdash;                         |                     &mdash;                      |
|                                                                                     |                                                     |                                                         |                                                  |
|       **S<br/>i<br/>g<br/>n<br/>i<br/>f<br/>i<br/>c<br/>a<br/>t<br/>o<br/>r**       |   ![](images/card-5.jpg?raw=true "5. Hierophant")   |    ![](images/card-12.jpg?raw=true "12. Hanged Man")    |    ![](images/card-19.jpg?raw=true "19. Sun")    |
|                                                                                     |                          :                          |                            :                            |                        :                         |
|                                        **=**                                        |                     **Choice**                      |                       **Choice**                        |                    **Choice**                    |
|                                                                                     |                                                     |                                                         |                                                  |
|                                                                                     |                       &mdash;                       |                         &mdash;                         |                     &mdash;                      |
|                                                                                     |                                                     |                                                         |                                                  |
| **T<br/>r<br/>a<br/>n<br/>s<br/>f<br/>o<br/>r<br/>m<br/>a<br/>t<br/>i<br/>o<br/>n** |     ![](images/card-6.jpg?raw=true "6. Lovers")     |      ![](images/card-13.jpg?raw=true "13. Death")       | ![](images/card-20.jpg?raw=true "20. Judgement") |
|                                                                                     |                          :                          |                            :                            |                        :                         |
|                **G<br/>r<br/>e<br/>a<br/>t<br/><br/>W<br/>a<br/>y**                 |    ![](images/card-7.jpg?raw=true "7. Chariot")     |    ![](images/card-14.jpg?raw=true "14. Temperance")    |   ![](images/card-21.jpg?raw=true "21. World")   |
|                                                                                     |                                                     |                                                         |                                                  |

## How

[Urbit](https://urbit.org/) would be needed to run this.

It started as a [Hoon School](https://hooniversity.org) final exercise.

So far it's just a generator, which I plan to turn into a Landscape app,
after [learning all of this](https://github.com/timlucmiptev/gall-guide) too.

## Use

The command below, entered in a dojo, generates an overview cheat-sheet.
This is the big picture, usually enough to jog one's memory with.

```
> +tarot, =o %all
~[
  [%all "|                  Mind           | Body             | Spirit    |"]
  [%all "|                                                                |"]
  [%all "| Matrix         | Magician       | Strength         | Devil     |"]
  [%all "| Potentiator    | High Priestess | Hermit           | Tower     |"]
  [%all "| Catalyst       | Empress        | Wheel of Fortune | Star      |"]
  [%all "| Experience     | Emperor        | Justice          | Moon      |"]
  [%all "| Significator   | Hierophant     | Hanged Man       | Sun       |"]
  [%all "| Choice Pairs                                                   |"]
  [%all "| Transformation | Lovers         | Death            | Judgement |"]
  [%all "| Great Way      | Chariot        | Temperance       | World     |"]
  [%all "| The Choice     | Choice                                        |"]
]
```

Here is a default example - I just called `+tarot` to get a random card:

```
~[
  [%upon "| = Archetype  | @ Mind    | Body    | Spirit |"]
  [%upon "|                                             |"]
  [%upon "| Catalyst     | : Empress                    |"]
  [%upon "| Experience > | = Emperor | Justice | Moon   |"]
  [%upon "|                # 4                          |"]
]
```

Above I got the Emperor archetype. It is card #4, of the Mind complex,
which together with Justice for Body and Moon for Spirit represents Experience.
It also pairs with the Empress Catalyst.

To get a specific card, for example the Sun, one could ask for it by name
`+tarot, =name "sun"` or number `+tarot, =a 19`:

```
~[
  [%upon "| = Archetype    | Mind       | Body       | @ Spirit |"]
  [%upon "|                                                     |"]
  [%upon "|                                            # 19     |"]
  [%upon "| Significator > | Hierophant | Hanged Man | = Sun    |"]
  [%upon "| The Choice                                 : Choice |"]
]
```
