## Purpose

Define the learner-facing local website that presents the curriculum, makes browser audio calls through FreeSWITCH, displays live evidence, and validates labs without exposing arbitrary control surfaces.

## ADDED Requirements

### Requirement: Course navigation and progress
The website SHALL present the 30 lessons as an ordered learning map, render the selected locale, show prerequisites and phase outcomes, and retain learner completion state locally without requiring an account.

#### Scenario: Learner resumes the course
- **WHEN** a learner returns in the same browser after marking lessons complete
- **THEN** the website restores the recorded progress
- **THEN** the learner can open any lesson without losing progress

#### Scenario: Translation is unavailable
- **WHEN** a requested locale does not contain a lesson
- **THEN** the website falls back to the Chinese lesson and visibly identifies the fallback locale

### Requirement: Browser SIP/WebRTC audio client
The website SHALL let a learner grant microphone access, connect to a configured FreeSWITCH SIP WebSocket endpoint, authenticate and register a tutorial user, place and receive audio calls, send DTMF, hang up, select available audio devices, and observe call state.

#### Scenario: Browser calls a SIP softphone
- **WHEN** the browser is registered and the learner dials a registered SIP extension
- **THEN** FreeSWITCH establishes a bidirectional audio call between the browser and the SIP endpoint
- **THEN** the website reports connecting, ringing, established, and terminated states

#### Scenario: Browser calls the IVR
- **WHEN** the learner calls the tutorial IVR extension and presses a valid menu digit
- **THEN** the DTMF digit reaches FreeSWITCH
- **THEN** the call follows the documented IVR branch and the corresponding event is visible

#### Scenario: Browser media setup fails
- **WHEN** microphone permission, secure context, WSS certificate validation, SIP registration, SDP negotiation, or audio-device setup fails
- **THEN** the website reports the failing stage and an actionable diagnostic next step without exposing credentials

### Requirement: Environment and live evidence panels
The website SHALL display the availability of the teaching service, FreeSWITCH, ESL, SIP profile, event feed, and latest heartbeat while keeping lesson content readable during runtime outages.

#### Scenario: FreeSWITCH becomes unavailable
- **WHEN** the teaching service cannot reach FreeSWITCH or ESL
- **THEN** the website enters a degraded state, identifies unavailable live features, and continues serving lesson content

#### Scenario: Events are received
- **WHEN** relevant call, bridge, hangup, heartbeat, or tutorial custom events occur
- **THEN** the website displays a bounded, time-ordered event stream with sensitive fields redacted

### Requirement: Safe lab validation
The website SHALL expose named validation checks for supported lessons and SHALL reject arbitrary shell commands, arbitrary file access, arbitrary FreeSWITCH API commands, and validation identifiers not declared by the tutorial.

#### Scenario: Learner runs a declared check
- **WHEN** a learner invokes the validation associated with the current lesson
- **THEN** the website returns pass, fail, or unavailable with evidence and a remediation hint

#### Scenario: Client submits an undeclared operation
- **WHEN** a client attempts to supply a command, path, or unknown validation identifier
- **THEN** the service rejects the request without executing the supplied operation

### Requirement: Credential and network protection
The website SHALL keep ESL and service credentials on the server, SHALL avoid returning SIP passwords after configuration, and SHALL require a secure browser context and trusted WSS when accessed beyond the localhost development exception.

#### Scenario: Browser requests runtime configuration
- **WHEN** the website returns connection defaults or health details
- **THEN** no ESL password, SIP password, authorization header, digest nonce, private key, or unrestricted control endpoint is included

