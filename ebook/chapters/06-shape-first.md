# 6. Get the shape right first

## Walls and furniture

When a clinic gets built, some decisions are easy to change later and some aren't. You can move chairs, repaint, and swap out a desk in an afternoon. You can't cheaply move the walls, the plumbing, or where the exam rooms sit relative to the waiting area. Get the floor plan wrong and every day afterward, staff walk extra steps and patients wait in the wrong place.

Software has walls and furniture too. The walls are the shape of your data and the major divisions of your code. The furniture is individual screens, buttons, and bits of logic. pstack's principle of foundational thinking puts it this way:

> Structural decisions protect option value. Code-level decisions protect simplicity.

"Option value" means your freedom to make changes later. Good structure keeps that freedom. Bad structure spends it, and every future change costs more.

Agents almost never stop to think about walls. They start placing furniture immediately, and after a few weeks of requests you have a building nobody would have designed on purpose.

## Data first

pstack's first rule of foundational thinking is to get the shape of the data right before writing logic. Decide what things exist, what information each one holds, and how they relate. Then trace how the data will be read and changed, and choose a structure that makes the common paths easy.

Here's a concrete case. ClinicDesk needs to know the status of each shift. An agent building quickly often does something like this:

```text
isOpen: true or false
isClaimed: true or false
isCancelled: true or false
isCompleted: true or false
```

Four yes-or-no switches look simple. But four switches allow sixteen combinations, and most of them are nonsense. A shift could be open and claimed at the same time, or cancelled and completed. Nothing in the structure stops those combinations from happening. So every piece of code that reads a shift has to guess how to handle them, and different pieces guess differently. That's where the bugs come from.

A better shape says what a shift actually goes through.

```text
status: one of "open", "claimed", "completed", "cancelled"
```

Now a shift is in exactly one state. The nonsense combinations can't exist, and code that reads the status has four cases to handle, not sixteen.

A hospital bed board works the same way. A patient is waiting, roomed, being seen, or discharged. Nobody runs the board as four separate yes-or-no columns, because then someone could be marked both "waiting" and "discharged," and the charge nurse would have to figure out which one is true.

## Model the domain

"Domain" means the real-world subject your software is about. For ClinicDesk, the domain is shifts, staff, appointments, and reminders. pstack's principle is to encode the domain in a data structure instead of scattering it across conditionals.

A conditional is an if-then check in code. "If the user is a manager, show the Post Shift button." A few are normal. The problem is when the same knowledge ends up spread across dozens of them in different files.

The structures pstack suggests reaching for:

- **A state machine instead of scattered switches.** That's the shift status example above. You list the states and the allowed moves between them. An open shift can become claimed or cancelled. A claimed shift can become completed or cancelled. Nothing else is allowed.
- **A lookup table instead of a growing chain of if-then checks.** If reminders go out 24 hours before a physical, 48 hours before a procedure, and 2 hours before a follow-up, that's a table with three rows, not a chain of three checks buried in the reminder code. Adding a fourth appointment type means adding a row.
- **A single typed record instead of loose pieces passed around.** If every part of the code passes around "name, phone, role, clinic" as four separate values, bundle them into one "staff member" record.
- **Modules organized by what they know, not by when they run.** A common mistake is to split code into "load," "check," "change," and "save" stages. Then the rules about shifts get repeated in all four stages. It's better to have one module that owns everything about shifts.

pstack names the warning signs that this step got skipped:

> A new feature that grows an existing if/else chain by one more branch, or a second boolean that must stay in sync with the first.

If you see an agent adding "one more case" to a long list of checks, or adding a new yes-or-no field that has to agree with another one, stop and ask whether a better structure is missing.

pstack also warns against overdoing it. An abstraction is a shared piece of code that stands in for several similar ones. Don't force one. If the current code is clear, local, and unlikely to grow, leave it boring. From foundational thinking:

> Three similar statements still beat a premature abstraction.

An abstraction is only worth it if it removes duplicated rules, removes if-then paths, or makes bad states impossible. If it just adds another layer, it makes things worse.

## Put the foundations in first

The second half of foundational thinking is about order. If something helps every later step, do it first.

In software, this "scaffold" includes the automatic checks from chapter 2, like tests, the linter, and CI, plus shared definitions of your core data. pstack's question is:

> Does every subsequent phase benefit from this existing?

If yes, it goes first. Setting up tests before fixing bugs means every fix can be checked. Defining what a shift is before building five screens that show shifts means all five agree.

## Don't bolt it on

Requirements change. Your clinic customer asks for shifts that repeat every week. The fast approach is to bolt that onto the existing design. Add a "repeats" field, add special handling in the places that break, and move on. Do that a few times and the design is a patchwork.

pstack's principle, redesign from first principles, says to integrate the change as if it had been a requirement from day one.

1. Read everything the change affects.
2. Ask, "If we were building this from scratch knowing about repeating shifts, what would we build?"
3. Carry the change through everything that refers to it, including the data, the screens, the documentation, and the tests.
4. Plan the whole redesign, then deliver it in small steps.

That last point matters. Redesigning doesn't mean rewriting everything at once. It means knowing where you're going before taking the first step.

## Try more than one design

When there's no obvious right answer, the first idea is rarely the best one. It's just the first. pstack's principle, exhaust the design space, says to build two or three competing versions and compare them side by side before committing. Another name for this is "design it twice."

This applies when:

- You're building an interaction nobody has built before in your product.
- There are several reasonable ways to structure something.
- Whether it's right depends on how it feels to use, not on logic.

It doesn't apply to routine work that follows an established pattern, or to bug fixes with a clear target.

pstack is strict about what counts as a real alternative:

> A second flavor of the first shape does not count.

Two layouts that differ only in button color are one design. Two layouts where one is a calendar and one is a list are two designs.

## Prototypes are for deciding

A prototype is a quick, throwaway version built to answer a question. pstack's prototype playbook is the one place where its usual rules on quality flip. Speed beats polish, and code quality doesn't matter, because the code will be thrown away. The rigor goes into picking the right design cheaply.

The playbook's steps, simplified:

1. **Name the decision.** "Calendar view or list view for open shifts?" If there's no decision to make, you don't need a prototype.
2. **Build it separately from the real product.** Use a scratch folder with the simplest tools that show the idea. Skip tests and structure.
3. **Put alternatives behind a switch.** If you're comparing three layouts, put all three in one page with buttons to flip between them. Seeing them side by side makes the comparison easy.
4. **Look at the real thing.** Click through each version. For a question about timing or behavior, run it and watch what happens.
5. **Decide, then build properly.** The output is a decision. Then you build the chosen version for real, with the usual standards.

```text
I'm not sure whether open shifts should be a calendar or a list. Build a throwaway prototype in a separate folder with both, plus one other idea you think could work, and a button to switch between them. Use fake data. This code won't be kept.
```

This is also where pstack's rule about factual questions from chapter 3 comes in. If an agent asks, "Should this be a calendar or a list?", a prototype often answers better than your guess. You can look at both and decide.

## Sketch before building

For changes that cross between parts of the system, pstack uses an `architect` skill that designs before implementing. You don't need the skill to use its method.

**Start with how it will be used.** Before anything else, write out how the rest of the code will use the new piece. If the scheduling screen needs to ask "can this nurse take this shift?", the design starts from that question. Designing from the user's side keeps the piece simple to use.

**Sketch the shapes, not the details.** Name the records, what goes in and out of each function, and which module owns what, with the insides left empty. This is cheap to change, and code isn't.

**Get more than one sketch.** At least two structurally different designs, compared before choosing.

**Screen for red flags.** pstack lists four signs of a bad design.

- **Shallow module.** A piece with a big, complicated set of controls that hides very little. Using it means learning how it works inside anyway. A good piece is the opposite. It has a small, simple interface over a lot of hidden work, like a microwave's "Popcorn" button.
- **Information leakage.** The same internal detail shows up in several places, so changing it means editing all of them. If three modules all know that phone numbers get stored without dashes, that knowledge has leaked.
- **Organized by time instead of knowledge.** This is the load, check, change, save split from earlier in the chapter.
- **Pass-through.** A function that just hands its inputs to another function unchanged. That's a layer that does nothing.

**Throw out a design that keeps needing workarounds.** Sometimes the build shows the sketch was wrong. pstack says the signal is a pattern, not a single problem. Watch for the same kind of workaround showing up in unrelated places, or many unrelated special cases, or code that needs to know a piece's internals to use it. When you see a pattern like that, stop adding patches. Redesign as if the new facts had been known from the start, and make the new design smaller than the old one before letting it grow.

```text
Before writing code for repeating shifts, sketch two different designs. For each, show how the scheduling screen would use it, what data it stores, and which parts of the code change. Check each against these red flags: shallow modules, the same detail repeated in several places, code organized by step order, and pass-through layers. Recommend one and explain why.
```

## In practice

- Decide the shape of the data before any logic gets written.
- Replace groups of yes-or-no fields with a single status that can only be one thing.
- Replace growing chains of special cases with tables or clear structures.
- Put tests and shared definitions in place before features.
- When requirements change, redesign as if they'd been there from the start. Don't bolt them on.
- When the answer isn't obvious, compare two or three real alternatives, using throwaway prototypes if needed.
