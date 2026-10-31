## Purpose

Define a small teaching-oriented FreeSWITCH module that exposes the essential module, application, API, channel, event, Metrics, and testing concepts needed for practical C/C++ extension work.

## ADDED Requirements

### Requirement: Independent module lifecycle
The teaching module SHALL build as a loadable FreeSWITCH module, report successful load, expose its registered interfaces while loaded, release owned resources on unload, and keep its configuration and examples outside `conf/vanilla`.

#### Scenario: Module is loaded and unloaded
- **WHEN** a learner builds and loads the module in the tutorial environment
- **THEN** the registered tutorial API and application become discoverable and callable
- **WHEN** the learner unloads the module while no protected operation is active
- **THEN** its interfaces and background resources are removed without stopping FreeSWITCH

### Requirement: Tutorial dialplan application
The module SHALL provide a dialplan application that accepts a documented IVR menu and choice, validates its input, records the choice, sets documented channel variables, and emits a tutorial custom event correlated to the current session.

#### Scenario: Valid IVR choice is recorded
- **WHEN** the application runs on a live channel with a valid menu and choice
- **THEN** it increments the matching counter, sets the documented result variables, and emits a custom event containing the menu, choice, timestamp, and session correlation identifier

#### Scenario: Invalid application input is supplied
- **WHEN** required input is absent, malformed, or outside the documented bounds
- **THEN** the application leaves the channel in a safe state, does not increment a choice counter, and returns a diagnosable failure result

### Requirement: Tutorial API
The module SHALL provide a read-only API that returns module status and a consistent snapshot of tutorial counters in both human-readable and machine-readable forms.

#### Scenario: Metrics snapshot is queried
- **WHEN** the API is called with the machine-readable option
- **THEN** it returns a valid structured response containing version, uptime, total application invocations, invalid invocations, and per-choice counters

#### Scenario: Unsupported API option is supplied
- **WHEN** the API receives an unsupported option
- **THEN** it returns usage information and does not mutate module state

### Requirement: Concurrency-safe observation
The module SHALL produce consistent counter snapshots and valid events when multiple channels invoke the application concurrently.

#### Scenario: Calls choose IVR branches concurrently
- **WHEN** multiple sessions invoke the application at the same time
- **THEN** no completed invocation is lost or counted more than once
- **THEN** every emitted event remains associated with the invoking session

### Requirement: Teachable verification
The module SHALL include automated tests for parsing, counter behavior, API output, event fields, invalid input, and lifecycle-sensitive behavior, plus an integration procedure that invokes it through a tutorial dialplan.

#### Scenario: Module tests are run
- **WHEN** the documented module test command runs in the supported build environment
- **THEN** deterministic unit tests run without requiring a production SIP trunk
- **THEN** the separate integration check states whether a running FreeSWITCH instance is required

