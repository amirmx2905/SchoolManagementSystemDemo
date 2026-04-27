# Requirements Analysis

## Functional Requirements

| ID  | Requirement | Priority | Complexity |
|-----|-------------|----------|------------|
| FR1 | System allows student registration | High | Medium |
| FR2 | System allows course creation and enrollment | High | Medium |
| FR3 | System allows grade registration | Medium | Low |
| FR4 | System authenticates users via JWT | High | High |
| FR5 | System sends email notifications | Low | Medium |

## Non-Functional Requirements

| ID   | Requirement | Priority | Complexity |
|------|-------------|----------|------------|
| NFR1 | 99% availability | High | High |
| NFR2 | Secrets never stored in code | High | Medium |
| NFR3 | Database lives in private subnet | High | Low |
| NFR4 | Infrastructure reproducible via Terraform | High | Medium |
