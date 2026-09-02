## Purpose

Define observable health, event, and Prometheus Metrics behavior for the tutorial so learners can connect FreeSWITCH runtime evidence to calls, IVR choices, failures, and capacity signals.

## ADDED Requirements

### Requirement: ESL connection lifecycle
The teaching service SHALL maintain an authenticated ESL connection, subscribe only to the events needed by the tutorial, expose its current connection state, and retry interrupted connections without blocking lesson delivery.

#### Scenario: ESL connection is restored
- **WHEN** an established ESL connection is interrupted and FreeSWITCH later becomes reachable
- **THEN** the service reports the disconnected interval, reconnects with bounded backoff, restores subscriptions, and resumes event processing

#### Scenario: ESL authentication fails
- **WHEN** FreeSWITCH rejects the configured ESL credentials
- **THEN** the service reports an authentication-specific degraded state without logging or returning the password

### Requirement: Core and tutorial signal collection
The service SHALL derive live observations from FreeSWITCH `status`, `HEARTBEAT`, channel lifecycle events, bridge and hangup events, CDR completion data, and tutorial custom events while correlating records by session identifiers.

#### Scenario: A completed call is observed
- **WHEN** a call progresses through creation, answer or failure, and hangup
- **THEN** the service updates current-session, call-result, and duration observations exactly once for that call

#### Scenario: An IVR choice is observed
- **WHEN** the teaching module emits a valid IVR choice event
- **THEN** the service increments the corresponding menu and choice observation and makes the event available to the website

### Requirement: Prometheus exposition
The service SHALL expose Prometheus text format including at least `freeswitch_up`, `freeswitch_esl_connected`, `freeswitch_sessions_current`, `freeswitch_sessions_total`, `freeswitch_calls_total`, `freeswitch_call_duration_seconds`, `freeswitch_heartbeat_age_seconds`, and `freeswitch_ivr_choice_total` with bounded label values.

#### Scenario: Metrics are scraped while healthy
- **WHEN** a client requests the Metrics endpoint while FreeSWITCH and ESL are healthy
- **THEN** the response uses the Prometheus text content type and contains valid numeric samples for every required metric family

#### Scenario: Metrics are scraped during an outage
- **WHEN** FreeSWITCH or ESL is unavailable
- **THEN** availability metrics report zero and heartbeat age continues to increase
- **THEN** stale call and session data is not presented as current without an explicit staleness signal

### Requirement: Bounded and redacted event delivery
The service SHALL provide a time-ordered live event feed and bounded recent history while excluding credentials, authorization data, private keys, raw SDP, and other fields not required by the lessons.

#### Scenario: Browser subscribes to events
- **WHEN** a browser establishes an event-stream subscription
- **THEN** it receives subsequent permitted events in order and can distinguish event type, timestamp, and redacted correlation identifier

#### Scenario: Event volume exceeds retention
- **WHEN** incoming events exceed the configured history or client buffer limit
- **THEN** the service discards data according to a documented bounded policy and reports the drop count rather than growing memory without limit

### Requirement: Diagnostic health contract
The service SHALL expose health that distinguishes teaching-service readiness, FreeSWITCH reachability, ESL authentication, heartbeat freshness, SIP profile availability, and Metrics freshness.

#### Scenario: A dependency is degraded
- **WHEN** any monitored dependency is unavailable or stale
- **THEN** health output identifies the affected dependency, last successful observation time, and a safe diagnostic action

