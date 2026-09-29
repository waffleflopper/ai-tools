# 5. Build less

## More code is a cost

New builders tend to measure progress by how much got made. More features, more screens, more code. Agents make this worse, because they produce code nearly for free and almost never suggest removing any.

Every line of code has to be understood by the next person who reads it, and any line can break. pstack's introduction says the goal isn't to maximize lines of code, "in fact it's the opposite." In its author's words, "pstack helps you write less, but higher quality code."

Geriatric medicine has a word for what happens when you ignore this. Polypharmacy is when a patient takes so many medications that the drugs themselves become the problem. Each prescription made sense when it was written. Together they interact, cause side effects, and hide what's actually going on. The treatment is deprescribing, meaning you remove what isn't needed before you add anything new.

Four of pstack's principles are about deprescribing code.

## The laziness protocol

The name is a joke with a serious point. Aim for the most result with the least code and complexity. A senior engineer is "lazy" in the sense that they refuse to build what doesn't need to exist.

The laziness protocol says to:

- **Prefer deletion.** When asked to improve something, look for what to remove before looking for what to add.
- **Make the smallest change that solves the problem.** Fewer lines beat "elegant" repetitive setup code. A change that touches three lines is easier to check than one that touches three hundred.
- **Keep the path short.** If answering a simple question means tracing through more than three files or layers, the structure is too deep.
- **Make each decision in one place.** If "is this user a manager?" gets decided in twelve different spots, those spots will eventually disagree. Decide it once and pass the answer along.
- **Question anything that threads a new value through many layers.** If a small feature means passing a new piece of information through five parts of the system, stop and look for a more direct route.
- **Fix small leaks early.** A little duplication or a pointless pass-through looks harmless. It spreads, because agents copy whatever patterns already exist in the code.

pstack's test for all of this is a human one:

> If a human developer would find the code exhausting to maintain, it is a bad solution.

## Subtract before you add

When you change a system, remove what's unneeded first, then build.

This order matters more than it sounds. Say ClinicDesk has three different ways to format a date, left behind by three different agent sessions. You now want to add time zones. If you add time-zone support to all three, you've tripled your work and kept the mess. If you first delete two and move everything onto one, you add time zones in one place. Often, once the dead weight is gone, the right design becomes obvious.

pstack's version of the rule includes a few specifics worth knowing:

- **Cut before you polish.** Get to the minimum first. Don't spend effort making something nice that shouldn't exist.
- **Design for how people actually use it, not for edge cases you imagine.** Agents love to add handling for situations that never happen. Each one is code to maintain.
- **Don't add checks the requirements don't call for.** Extra "just in case" validation looks responsible. In practice it clutters the code and hides where the real checks are. Chapter 7 explains where checks belong.
- **Delete, don't stub.** When something is no longer needed, remove it entirely. Don't leave behind an empty placeholder that points at it.

A good way to use this with an agent:

```text
Before adding anything, look at the reminder code and tell me what can be deleted or merged. Do that cleanup as its own change first. Then add the email option on top of the simpler version.
```

pstack also asks you to make simplification a habit. Each time you touch an area, try to leave it a little simpler and more capable than you found it.

## Minimize reader load

Code is read many more times than it's written. Every time you or an agent needs to change something, someone has to read and understand the code first. pstack says the real measure of maintainable code is how much work that reader has to do, and it names two kinds of work.

**Layers to trace.** How many hops sit between a question and its answer. If "what time does the reminder go out?" means following a trail from one file to another to a third to a settings file to a fourth, that's five layers.

**State to hold.** How much changing information the reader has to keep in their head. If the reminder time can be changed by six different parts of the program at different moments, the reader has to track all six to know what will happen.

These two are independent. One huge file full of values that anything can change is as hard to follow as a neat stack of six layers. Both are problems.

The fixes:

- **Remove layers that add nothing.** A common agent habit is to wrap a function in another function that does nothing but call the first one. That's a layer with no benefit. pstack calls these pass-throughs and one-caller wrappers, and it says to remove them.
- **Keep state as local as possible.** Information that only one small piece of code can change is easy to reason about. Information that anything anywhere can change is not.
- **Calculate values instead of copying them.** If you store a nurse's total hours in one place and their list of shifts in another, the two can drift apart. If you calculate total hours from the shift list whenever you need it, they can't disagree.

The test is simple enough to ask directly:

> Can a new reader answer "where does X come from?" and "what can change X?" in under 30 seconds?

This is the human version of the agent's context window. Your working memory is limited too.

## Experience first

The fourth principle is about what you build, not how. When doing something the easy way conflicts with doing it well for the user, choose the user.

- **Every feature, control, and option must justify itself.** Each one adds something to learn, test, and maintain.
- **Ship less and ship it better.** In pstack's words, a "polished experience with three features beats rough one with ten." A half-finished feature is worse than a missing one, because users find it, rely on it, and get burned.
- **Get the details right.** Transitions, spacing, feedback when a button is pressed, and clear error messages are part of the product.
- **Keep the core loop tight.** For ClinicDesk, the core loop is that a shift gets posted and gets filled. Every feature should help that loop or stay out of its way.

pstack widens the idea of "user" too. The user is whoever consumes the work. For a screen, that's the person using it. For code, it's the next person who has to change it. Design for both.

## Why agents need this pushed on them

Agents lean toward adding. Ask one to fix a bug and it may add a check that hides the symptom. Ask for a feature and it may build a settings page with options nobody asked for. Ask it to "clean up" and it may reorganize everything into new layers. None of this is malicious. It's the default. You have to ask for subtraction explicitly.

Useful phrases:

```text
What's the smallest change that solves this?
```

```text
Is there anything we can delete instead?
```

```text
This feels like more than the job needs. What would you remove?
```

```text
Would a new reader be able to find where this value comes from in 30 seconds?
```

## In practice

- Treat every new line of code as a cost, not an achievement.
- Remove what isn't needed before adding anything.
- Ask for the smallest change that solves the problem.
- Watch for layers that only pass things along, and for values that can be changed from many places.
- Build fewer features and finish them properly.
