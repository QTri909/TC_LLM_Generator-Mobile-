I have the current UI code for my "Story Details" screen below:
    <!DOCTYPE html>
<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Story Details - AI Test Artifact Management</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#2b7cee",
                        "background-light": "#f6f7f8",
                        "background-dark": "#101822",
                    },
                    fontFamily: {
                        "display": ["Inter", "sans-serif"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
<style type="text/tailwindcss">
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .checkbox-custom {
            --checkbox-tick-svg: url('data:image/svg+xml,%3csvg viewBox=%270 0 16 16%27 fill=%27rgb(255,255,255)%27 xmlns=%27http://www.w3.org/2000/svg%27%3e%3cpath d=%27M12.207 4.793a1 1 0 010 1.414l-5 5a1 1 0 01-1.414 0l-2-2a1 1 0 011.414-1.414L6.5 9.086l4.293-4.293a1 1 0 011.414 0z%27/%3e%3c/svg%3e');
        }
        .segmented-control {
            height: 36px;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background-light dark:bg-background-dark font-display min-h-screen flex flex-col">
<div class="sticky top-0 z-20 flex flex-col bg-white dark:bg-background-dark border-b border-gray-100 dark:border-gray-800">
<div class="flex items-center p-4 justify-between">
<div class="text-[#111418] dark:text-white flex size-12 shrink-0 items-center cursor-pointer">
<span class="material-symbols-outlined">arrow_back_ios</span>
</div>
<div class="flex flex-col items-center flex-1 text-center">
<span class="text-[10px] text-gray-500 dark:text-gray-400 uppercase font-bold tracking-widest leading-none mb-0.5">Project: Calendar Pro</span>
<h2 class="text-[#111418] dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Story Details</h2>
</div>
<div class="flex w-12 items-center justify-end gap-1">
<button class="flex size-10 cursor-pointer items-center justify-center rounded-full bg-transparent text-[#111418] dark:text-white">
<span class="material-symbols-outlined">more_horiz</span>
</button>
</div>
</div>
<div class="px-4 pb-3">
<div class="flex p-1 bg-gray-100 dark:bg-gray-800 rounded-full segmented-control items-center">
<button class="flex-1 h-full text-[13px] font-semibold rounded-full transition-all bg-white dark:bg-gray-700 text-[#111418] dark:text-white shadow-sm flex items-center justify-center">
                    Story
                </button>
<button class="flex-1 h-full text-[13px] font-semibold rounded-full transition-all text-gray-500 dark:text-gray-400 flex items-center justify-center">
                    Test Case
                </button>
<button class="flex-1 h-full text-[13px] font-semibold rounded-full transition-all text-gray-500 dark:text-gray-400 flex items-center justify-center">
                    Test Plan
                </button>
</div>
</div>
</div>
<main class="flex-1 overflow-y-auto pb-40">
<div class="px-4 pt-6 flex items-center justify-between">
<span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-semibold uppercase tracking-wider">
<span class="size-2 rounded-full bg-primary"></span>
                Ready for Testing
            </span>
<div class="flex items-center gap-1 text-gray-400 dark:text-gray-500">
<span class="material-symbols-outlined text-sm">folder_open</span>
<span class="text-[11px] font-medium">Calendar Pro</span>
</div>
</div>
<div class="p-4 @container">
<div class="flex flex-col items-stretch justify-start rounded-xl shadow-sm bg-white dark:bg-gray-900 overflow-hidden border border-gray-100 dark:border-gray-800">
<div class="w-full bg-center bg-no-repeat aspect-video bg-cover" style='background-image: url("https://lh3.googleusercontent.com/aida-public/AB6AXuCTXOKDLk9wP19cOHQ05LcOPayOY0gxkoXYlgAzy6UZxRxNSeOmxDdjN3o5wLRpeVVCnDeioEfSfEfs9YTyM_W5jr7Fu0Wz2Arp7LKuwIOi3F50de1FsGhGMt7edMtYeP65J-DXJd4b4LjGP0-TbyKw_1eSNU4qAeckILsqmJfFDUFHXiaJSsW8lctncDILjzR69LeiXSeUfC1EZ9hgaEXhIUk9Ofi6ygXNKq5Jied6-ifEgSA6meCO8pXoYJbBTrUEHt-ahTqQIBw1");'>
</div>
<div class="flex w-full min-w-72 grow flex-col items-stretch justify-center gap-4 py-6 px-5">
<div>
<p class="text-primary text-sm font-bold uppercase tracking-widest mb-1">US-102</p>
<p class="text-[#111418] dark:text-white text-xl font-extrabold leading-tight tracking-[-0.015em]">Calendar Synchronization</p>
</div>
<div class="space-y-3">
<div class="flex gap-3">
<span class="text-primary font-bold min-w-[75px] text-sm whitespace-nowrap">As a</span>
<p class="text-gray-600 dark:text-gray-400 text-sm font-normal">Product Manager</p>
</div>
<div class="flex gap-3 border-t border-gray-50 dark:border-gray-800 pt-3">
<span class="text-primary font-bold min-w-[75px] text-sm whitespace-nowrap">I want to</span>
<p class="text-gray-600 dark:text-gray-400 text-sm font-normal">sync my calendar</p>
</div>
<div class="flex gap-3 border-t border-gray-50 dark:border-gray-800 pt-3">
<span class="text-primary font-bold min-w-[75px] text-sm whitespace-nowrap">So that</span>
<p class="text-gray-600 dark:text-gray-400 text-sm font-normal">I can see my deadlines in one place.</p>
</div>
</div>
</div>
</div>
</div>
<div class="flex items-center justify-between px-4 pb-2 pt-4">
<h3 class="text-[#111418] dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Acceptance Criteria (4)</h3>
<span class="material-symbols-outlined text-gray-400">playlist_add_check</span>
</div>
<div class="px-4 checkbox-custom">
<div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-100 dark:border-gray-800 divide-y divide-gray-50 dark:divide-gray-800 overflow-hidden">
<label class="flex gap-x-4 px-4 py-4 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
<input checked="" class="mt-0.5 h-6 w-6 rounded border-gray-300 dark:border-gray-600 border-2 bg-transparent text-primary checked:bg-primary checked:border-primary checked:bg-[image:--checkbox-tick-svg] focus:ring-0 focus:ring-offset-0 focus:border-primary focus:outline-none" type="checkbox"/>
<p class="text-[#111418] dark:text-gray-200 text-base font-normal leading-snug">Syncing must happen in real-time when a record is updated.</p>
</label>
<label class="flex gap-x-4 px-4 py-4 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
<input class="mt-0.5 h-6 w-6 rounded border-gray-300 dark:border-gray-600 border-2 bg-transparent text-primary checked:bg-primary checked:border-primary checked:bg-[image:--checkbox-tick-svg] focus:ring-0 focus:ring-offset-0 focus:border-primary focus:outline-none" type="checkbox"/>
<p class="text-[#111418] dark:text-gray-200 text-base font-normal leading-snug">Error message shows clearly if the provider API fails or times out.</p>
</label>
<label class="flex gap-x-4 px-4 py-4 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
<input class="mt-0.5 h-6 w-6 rounded border-gray-300 dark:border-gray-600 border-2 bg-transparent text-primary checked:bg-primary checked:border-primary checked:bg-[image:--checkbox-tick-svg] focus:ring-0 focus:ring-offset-0 focus:border-primary focus:outline-none" type="checkbox"/>
<p class="text-[#111418] dark:text-gray-200 text-base font-normal leading-snug">User can safely disconnect their calendar in the account settings menu.</p>
</label>
<label class="flex gap-x-4 px-4 py-4 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
<input class="mt-0.5 h-6 w-6 rounded border-gray-300 dark:border-gray-600 border-2 bg-transparent text-primary checked:bg-primary checked:border-primary checked:bg-[image:--checkbox-tick-svg] focus:ring-0 focus:ring-offset-0 focus:border-primary focus:outline-none" type="checkbox"/>
<p class="text-[#111418] dark:text-gray-200 text-base font-normal leading-snug">Supports OAuth 2.0 authentication for Google and Outlook calendars.</p>
</label>
<div class="px-4 py-3 bg-gray-50/50 dark:bg-gray-800/30">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-gray-400">add_circle</span>
<input class="w-full bg-transparent border-none focus:ring-0 text-sm py-2 placeholder-gray-400 dark:text-white" placeholder="Add Acceptance Criteria..." type="text"/>
</div>
</div>
</div>
</div>
</main>
<div class="fixed bottom-0 left-0 right-0 bg-white/80 dark:bg-background-dark/80 backdrop-blur-lg border-t border-gray-100 dark:border-gray-800 pb-10 pt-4 px-4">
<div class="max-w-md mx-auto flex flex-col gap-3">
<button class="flex w-full cursor-pointer items-center justify-center overflow-hidden rounded-xl h-14 bg-primary text-white gap-3 shadow-lg shadow-primary/30 transition-transform active:scale-95">
<span class="material-symbols-outlined fill-1">auto_awesome</span>
<span class="text-base font-bold leading-normal tracking-[0.015em]">Generate AI Test Cases</span>
</button>
</div>
</div>

</body></html>
I want to change the UX. Remove the floating "Generate AI Test Cases" button from the "Story" tab. Instead, go to the "Test Case" tab. If there are no test cases, display an "Empty State" UI inside that tab.

Please generate the code for this "Empty State" based on these exact specifications:

Create a Flutter UI for the "Empty State" of the "Test Case" tab inside the "Story Details" screen. 
The app uses Clean Architecture and BLoC. This UI should be displayed when there are no test cases generated yet.

**General Layout:**
* Center the content on the screen with proper padding (e.g., 24px).
* Use a Column to stack the elements vertically.

**Header Section:**
* Add a large, subtle illustration or a combined icon (e.g., an empty folder or a checklist with a magic wand) in a soft gray/blue tint.
* Title: "No Test Cases Yet" (Text: Large, Bold, Dark).
* Subtitle: "Choose how you want to create test cases for this User Story." (Text: Medium, Gray, centered text alignment).
* Add some vertical spacing (SizedBox).

**Action Cards (The core choices):**
Create two large, tapable cards (using GestureDetector or InkWell wrapped in Container/Card).

1.  **AI Generation Card (Primary Focus):**
    * Layout: Row with an Icon on the left, Text on the right.
    * Icon: "auto_awesome" (Sparkles/Magic) inside a circular primary blue background.
    * Title: "Generate with AI" (Bold, Primary Blue).
    * Subtitle: "Let LLM scan Acceptance Criteria and create tests in seconds." (Small, Gray).
    * Styling: Border slightly tinted with primary blue, very subtle blue background (e.g., blue with 5% opacity), rounded corners (16px).

2.  **Manual Creation Card (Secondary Focus):**
    * Layout: Row with an Icon on the left, Text on the right.
    * Icon: "edit_document" or "add" inside a circular gray background.
    * Title: "Write Manually" (Bold, Dark Gray).
    * Subtitle: "Create test cases step-by-step from scratch." (Small, Gray).
    * Styling: Standard gray border, white background, rounded corners (16px). Add a subtle drop shadow.

**Spacing & Responsiveness:**
* Add a 16px vertical gap between the two action cards.
* Ensure the UI is responsive and looks good on smaller mobile screens.

Ensure the new code perfectly matches the colors, styling, and Clean Architecture structure of my existing code.
