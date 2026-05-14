Always use shfmt to reformat bash scripts after making changes like so:

**Example**

shfmt -w -i 2 -ci -bn path/to/myscript.sh

---

When creating Jira tickets, use the Atlassian MCP with the following
configuration:

**Standard Fields:**

- **Project:** PLA
- **Assignee:** Robert Carosi (account ID: 5c33194a7d0c1a2f0111e8e4)
- **Labels:** <none> (do not add labels unless explicitly requested)

**Custom Fields:**

- **Team:** PLA Delivery (custom field ID: customfield_11100, team ID: 9f9c7c1c-5981-4ab5-a9aa-9f0e10fced54)

**Implementation:** When calling `atlassian_createJiraIssue`, use:

- `projectKey`: "PLA"
- `assignee_account_id`: "5c33194a7d0c1a2f0111e8e4"
- `additional_fields`: `{"customfield_11100": "9f9c7c1c-5981-4ab5-a9aa-9f0e10fced54"}`

**Example:**

```
atlassian_createJiraIssue(
  cloudId="picnic.atlassian.net",
  projectKey="PLA",
  issueTypeName="Task",
  summary="...",
  description="...",
  assignee_account_id="5c33194a7d0c1a2f0111e8e4",
  additional_fields={"customfield_11100": "9f9c7c1c-5981-4ab5-a9aa-9f0e10fced54"}
)
```

---

When working with Helm charts, always look in the following directory:

**Helm Charts Repository:** `/Users/carosi/Projects/picnic/picnic-helm-charts`

This repository contains all Helm charts for Picnic services and infrastructure.
