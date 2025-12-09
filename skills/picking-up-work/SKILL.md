---
name: picking-up-work
description: >
  Activates when starting implementation work, reviewing a CR, picking up a work
  item, asking what to work on, or beginning any TarkaFlow development task.
  Use before writing any code to ensure CR readiness and full context gathering.
---

# Picking Up Work

**Autonomous by default.** See [AUTONOMOUS.md](../AUTONOMOUS.md) for blocking vs non-blocking guidance.

Before writing any code, you MUST understand the full scope of the work. Gather context and proceed to test-readiness unless blocked.

## Step 1: Verify CR Exists and Is Approved

```
get_work_item(work_item_id='<CR-ID>')
```

**Check:**
- Status is `approved` or `in_progress`
- If `created` → CR needs approval, do not proceed
- If no CR exists → stop and inform user

## Step 2: Fetch All Affected Requirements

For each requirement ID in the CR's `affects` list:

```
get_requirement(requirement_id='<ID>')
```

**Extract and note:**
- Title and description
- Full content (the specification)
- Status (should be `approved`)
- Semantic tags (uses:, owns:, depends:)

## Step 3: Fetch Acceptance Criteria

For each affected requirement:

```
list_acceptance_criteria(requirement_id='<ID>')
```

**Assess each AC:**
- Is it specific? (not vague like "should be fast")
- Is it measurable? (has concrete success condition)
- Is it testable? (can write a test that passes/fails)

**If ACs are inadequate:**
- Note which ACs need clarification
- Consider creating clarification tasks
- Do not proceed until ACs are testable

## Step 4: Check Dependencies

For each affected requirement:

```
list_requirements(blocked_by='<requirement_id>')
```

**Check dependency status:**
- Are blocking dependencies code-complete? (has `deployed_version`)
- If dependencies are unmet → work is blocked, inform user

Also check the requirement's own `depends:` tags for explicit dependencies.

## Step 5: Gather Related Artifacts

**Find LDM entries:**
```
list_requirements(project_id='<project>', type='ldm')
```

Look for LDM entries referenced by `uses:` tags in affected requirements.

**Find Interface specs:**
```
list_requirements(project_id='<project>', type='interface')
```

Look for interfaces referenced by `uses:` tags.

**Fetch full content for relevant artifacts:**
```
get_requirement(requirement_id='<LDM-ID>')
get_requirement(requirement_id='<INTERFACE-ID>')
```

## Step 6: Summarise and Proceed

Log your understanding briefly, then proceed immediately to test-readiness:

```
## Picking Up: <CR-ID> - <title>
Status: <status>
Requirements: <count> affected
ACs: <count> total (<testable count> testable)
Dependencies: <met/unmet>
```

**Do NOT wait for confirmation.** Proceed to test-readiness unless blocked.

## Blocking (STOP)

- CR is not approved (status must be `approved` or `in_progress`)
- CR not found
- Critical dependencies not met (blocking work items incomplete)

## Non-Blocking (PROCEED)

- Minor AC ambiguity (interpret reasonably, note assumption)
- Missing optional LDM/interface details (implement what you can)
- Unclear implementation approach (choose sensible option)

If blocked, inform user of the specific blocker. Otherwise, proceed directly to test-readiness phase.
