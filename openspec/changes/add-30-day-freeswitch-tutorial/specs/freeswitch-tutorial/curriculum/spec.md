## Purpose

Define a progressive, source-backed 30-day curriculum that takes a developer from first FreeSWITCH operation to a working SIP/WebRTC, IVR, Metrics, and C/C++ extension capstone.

## ADDED Requirements

### Requirement: Thirty-day progression
The tutorial SHALL provide exactly 30 ordered daily lessons grouped into six five-day phases: FreeSWITCH foundations, SIP and media, WebRTC audio, IVR and ESL, C/C++ module development, and Metrics plus capstone integration.

#### Scenario: Learner follows the default path
- **WHEN** a learner opens the syllabus
- **THEN** the learner sees days 1 through 30 in order with each day assigned to one of the six phases
- **THEN** each phase states a concrete artifact or behavior the learner will complete

#### Scenario: Learner reaches the capstone
- **WHEN** a learner completes day 30
- **THEN** the learner has instructions to demonstrate browser-to-FreeSWITCH WebRTC audio, SIP interworking, a multi-level IVR, the teaching module, ESL event observation, and exported Metrics as one system

### Requirement: Consistent daily lesson contract
Every daily lesson SHALL contain a learning outcome, core theory, repository source navigation, a guided lab, an independent challenge, a deterministic validation procedure, troubleshooting guidance, and a Chinese-English terminology section.

#### Scenario: Lesson completeness is checked
- **WHEN** a lesson is validated as curriculum content
- **THEN** all required lesson sections are present and non-empty
- **THEN** commands, paths, module names, APIs, and expected results are traceable to the repository or the established lab environment

### Requirement: Theory is tied to observable practice
The curriculum SHALL connect protocol and architecture concepts to FreeSWITCH configuration, runtime observations, and relevant source locations rather than presenting theory or commands in isolation.

#### Scenario: SIP signaling is taught
- **WHEN** a lesson explains REGISTER, INVITE, SDP, RTP, WSS, ICE, DTLS-SRTP, or codec negotiation
- **THEN** it includes a corresponding call or diagnostic exercise
- **THEN** it identifies the relevant FreeSWITCH configuration and source entry points

#### Scenario: C/C++ development is taught
- **WHEN** a lesson introduces a module API or lifecycle concept
- **THEN** the learner modifies, builds, loads, invokes, observes, and tests a small behavior connected to that concept

### Requirement: Reproducible lab baseline
The curriculum SHALL use the documented Ubuntu/Debian Docker environment as its primary runtime baseline and SHALL state all additional prerequisites, ports, certificates, credentials, sounds, and client requirements needed by each lab.

#### Scenario: Learner starts from the supported baseline
- **WHEN** the documented prerequisites are satisfied
- **THEN** each guided lab can be completed without relying on an undocumented host service or production credential
- **THEN** the validation procedure distinguishes environment failure from lesson failure

### Requirement: Chinese-first localization structure
The initial complete curriculum SHALL be written in Chinese while preserving stable lesson identifiers, shared code, shared diagrams, commands, and terminology that can be reused by a later English locale.

#### Scenario: English content is added later
- **WHEN** an English translation for a lesson is introduced
- **THEN** it can use the same lesson identifier and shared lab assets without copying executable code or changing the Chinese lesson URL contract

### Requirement: Safe tutorial scope
The curriculum SHALL label vanilla credentials and configurations as demonstration-only, SHALL keep tutorial module configuration outside `conf/vanilla`, and SHALL explain when a lab action is unsafe outside an isolated environment.

#### Scenario: A lesson exposes a service or credential
- **WHEN** a lesson configures SIP, WSS, RTP, ESL, HTTP, or Metrics access
- **THEN** it states the intended network boundary and the minimum credential, TLS, and redaction precautions

