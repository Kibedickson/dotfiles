import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

const CUSTOM_TYPE = "readonly-mode";
const ENTRY_VERSION = 1;

const READONLY_RULES = `
# Read-only Mode

You are currently in read-only mode. Follow these rules:
- Do not create, modify, or delete files.
- Do not run commands that would change the filesystem (no writes, no rm, no mv, no chmod, etc.).
- You may read files and run read-only inspection commands.
- If the user asks for changes, explain what you would do instead of doing it.
`;

interface ReadonlyEntry {
	version: number;
	enabled: boolean;
}

export default function (pi: ExtensionAPI) {
	let enabled = false;

	const persist = (value: boolean) => {
		enabled = value;
		pi.appendEntry(CUSTOM_TYPE, { version: ENTRY_VERSION, enabled: value });
	};

	pi.on("session_start", async (_event, ctx) => {
		for (const entry of ctx.sessionManager.getEntries()) {
			if (entry.type === "custom" && entry.customType === CUSTOM_TYPE) {
				const data = entry.data as ReadonlyEntry;
				if (data?.version === ENTRY_VERSION) {
					enabled = data.enabled;
				}
			}
		}
	});

	pi.registerCommand("readonly", {
		description: "Toggle read-only mode (blocks writes/edits)",
		handler: async (_args, ctx) => {
			const next = !enabled;
			persist(next);
			ctx.ui.notify(next ? "Read-only mode ON" : "Read-only mode OFF", "info");
		},
	});

	pi.on("before_agent_start", async (_event, ctx) => {
		if (!enabled) return;
		return {
			systemPrompt: ctx.getSystemPrompt() + "\n\n" + READONLY_RULES,
		};
	});

	pi.on("tool_call", async (event, _ctx) => {
		if (!enabled) return;
		if (isToolCallEventType("write", event) || isToolCallEventType("edit", event)) {
			return {
				block: true,
				reason: "Blocked: read-only mode is active. Run /readonly to disable.",
			};
		}
	});
}
