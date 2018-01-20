module Components.SlotPicker where


import Components.DateTitle as DateTitle
import Components.SlotCell as SlotCell
import Components.TimeSlotTitle as TimeSlotTitle
import Data.Date (Date)
import Data.Newtype (unwrap)
import Data.Set (member)
import Prelude ((<$>))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import State (Error(NoSlot), State)
import StaticProps (StaticProps)


render :: _ -> StaticProps -> State -> ReactElement
render dispatch props state = R.div [RP.className "field"] [
    R.div [RP.className "is-flex"] [
      R.aside' [
        R.ul' [
          R.li [RP.className "table-header"] [],
          TimeSlotTitle.render Lunch range dispatch state,
          TimeSlotTitle.render Evening range dispatch state
        ]
      ],
      R.ul [RP.className "is-flex"] (renderRow <$> range)
    ],
    errorMessage
  ]

  where
    range :: Array Date
    range = (unwrap props).range

    renderRow :: Date -> ReactElement
    renderRow date = R.li [ RP.style {"min-width": 45, "max-width": 45} ] [
      DateTitle.render dispatch state date,
      SlotCell.render Lunch dispatch state date,
      SlotCell.render Evening dispatch state date
    ]

    fieldHasError :: Boolean
    fieldHasError = member NoSlot (unwrap state).errors
    errorMessage :: ReactElement
    errorMessage = if fieldHasError
                   then R.p [RP.className "help is-danger"] [R.text "Choisissez au moins un créneau"]
                   else R.p' []
