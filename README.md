# TimeTracker

This is an example Single Page Application in Elm, using
[elm-mdl](https://debois.github.io/elm-mdl/) for the UI widgets, that will
ultimately provide a basic, quasi-full-featured time tracker application
frontend in Elm.

This is a project built with detailed explanations along the way, and
incrementally, in the [DailyDrip](http://dailydrip.com) Elm topic.  Here it is
in action:

![Example](https://raw.github.com/knewter/time-tracker/master/resources/TimeTrackerWalkthrough.gif)

## Detailed walkthroughs

If you'd like to see detailed walkthroughs building this project, they're
available at the following URLs:

- [Basic CRUD in a Single Page Application](https://www.dailydrip.com/topics/elm/drips/basic-crud-in-a-single-page-application)
  - An initial pass at interacting with our backend API from an Elm SPA.
- [Cleaned up CRUD](https://www.dailydrip.com/topics/elm/drips/cleaned-up-crud)
  - Extracting an API module, deleting and viewing users, and dealing with API
    calls on page load based on the route.
- [Finishing a CRUD resource with a Sortable Table in elm-mdl](https://www.dailydrip.com/topics/elm/drips/finishing-a-crud-resource-with-a-sortable-table-in-elm-mdl)
  - Making our users list use a Material.Table and adding the ability to sort
    it.
- [Editing Users](https://www.dailydrip.com/topics/elm/drips/editing-users-and-a-week-of-refactoring)
  - Adding the ability to edit users.
- These two aren't the project but they are where we learned how to do
  Navigation in the style we're using here, and introduced elm-mdl:
  - [Intro to Navigation](https://www.dailydrip.com/topics/elm/drips/content-catalog-part-1-initial-setup)
  - [\[FREE\] `elm-mdl` Introduction](https://www.dailydrip.com/topics/elm/drips/elm-mdl-introduction)
    - There are a lot of additional mdl walkthroughs in the 2 weeks or so
      following that episode.

## Elm bits

The elm client lives in ./elm.  Look there for more info.

## Backend bits

I intend to ultimately write a basic
[Phoenix-based](http://phoenixframework.org) backend API server for providing a
nice means to give examples of persistence, loading data from a CRUD backend,
etc.  The current implementation is already alive, at `./time_tracker_backend`.

## License

MIT Licensed, see LICENSE for more details.
