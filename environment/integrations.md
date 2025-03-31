Integrations
============

InteractiveAI Integration
-------------------------
Here's an impression from the Olten scenario:

![Flatland](../assets/images/olten_interactive_ai.png)

FlatlandCallbacks for InteractiveAI (https://github.com/AI4REALNET/InteractiveAI).

The callbacks create context and events during a scenario run.
If an InteractiveAI instance is up and running, the callbacks send out HTTP POST requests to InteractiveAI contexts and events REST API endpoints.
In this notebook, we just log the contexts and events that would be sent out.

- The agent positions are sent as context, with geo-coordinates for display on a map.
- Agent malfunctions are sent as events.