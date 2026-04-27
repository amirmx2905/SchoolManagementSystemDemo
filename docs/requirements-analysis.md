# Requirements Analysis

## Functional Requirements

| ID  | Requirement                                  | Priority | Complexity | Dependencies              |
| --- | -------------------------------------------- | -------- | ---------- | ------------------------- |
| FR1 | System allows student registration           | High     | Medium     | FR4 (auth required)       |
| FR2 | System allows course creation and enrollment | High     | Medium     | FR1 (students must exist) |
| FR3 | System allows grade registration             | Medium   | Low        | FR2 (courses must exist)  |
| FR4 | System authenticates users via JWT           | High     | High       | None                      |
| FR5 | System sends email notifications             | Low      | Medium     | FR1 (needs user emails)   |

## Non-Functional Requirements

| ID   | Requirement                               | Priority | Complexity | Dependencies           |
| ---- | ----------------------------------------- | -------- | ---------- | ---------------------- |
| NFR1 | 99% availability                          | High     | High       | ALB + multi-AZ subnets |
| NFR2 | Secrets never stored in code              | High     | Medium     | Vault (Phase 6)        |
| NFR3 | Database lives in private subnet          | High     | Low        | VPC network module     |
| NFR4 | Infrastructure reproducible via Terraform | High     | Medium     | All Terraform modules  |

## Infrastructure Traceability

| Requirement | Covered by                                          |
| ----------- | --------------------------------------------------- |
| FR1–FR5     | EC2 app instances running microservices             |
| NFR1        | ALB + 2 EC2 instances across 2 AZs                  |
| NFR2        | HashiCorp Vault + no .env in repo                   |
| NFR3        | `modules/network` private subnets + SG-RDS          |
| NFR4        | `terraform/` modules + `terraform validate` passing |
