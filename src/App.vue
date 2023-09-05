<template>
    <main class="flex flex-col items-center justify-center w-full h-full">
        <label class="flex gap-3">
            <span>Show events:</span>
            <input type="range" min="0" :max="events.length + 1" v-model="revealed" />
        </label>

        <ul class="relative self-stretch m-24 bg-gray-300 h-1 mt-40">
            <li
                v-for="marker of computedMarkers"
                :key="marker.timestamp"
                class="absolute top-1/2 -translate-y-1/2 w-1 h-24 bg-gray-300"
                :style="`left: ${marker.delta * 100}%`"
            >
                <span class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-full text-lg">
                    {{ marker.name }}
                </span>
            </li>
            <li
                v-for="(event, i) in computedEvents"
                class="flex items-center text-white justify-center font-bold absolute top-1/2 -translate-y-1/2 w-10 h-10 rounded-full"
                :class="{
                    'bg-[#b7d8c3]': revealed <= i,
                    'bg-green-700': revealed > i,
                    'ring ring-green-700 ring-offset-2': i == revealed - 1,
                }"
                :key="event.timestamp"
                :style="`left: ${event.delta * 100}%`"
            >
                <span
                    v-if="revealed > i && i != revealed - 1"
                    class="text-green-700 absolute left-1/2 -translate-x-1/2 whitespace-nowrap bg-white/75"
                    :class="{
                        'top-0 -translate-y-full': !event.renderBelow,
                        'top-full': event.renderBelow,
                    }"
                >
                    {{ event.name }}
                </span>
            </li>
        </ul>
    </main>
</template>

<script setup lang="ts">
import { range as arrayRange } from '@noeldemartin/utils';
import { ref } from 'vue';

interface EventDate {
    month: number;
    year: number;
}

interface Event {
    name: string;
    date: EventDate;
    renderBelow?: boolean;
}

const enum Months {
    January = 1,
    February = 2,
    March = 3,
    April = 4,
    May = 5,
    June = 6,
    July = 7,
    August = 8,
    September = 9,
    October = 10,
    November = 11,
    December = 12,
}

const today: EventDate = { // MoodleMoot 2023
    month: Months.September,
    year: 2023,
};
const events: Event[] = [
    {
        name: 'Initial Release',
        date: {
            month: Months.April,
            year: 2013,
        },
    },
    {
        name: 'Manual Tests',
        date: {
            month: Months.July,
            year: 2016,
        },
    },
    {
        name: 'Behat Steps',
        date: {
            month: Months.February,
            year: 2019,
        },
    },
    {
        name: 'Behat Tests',
        date: {
            month: Months.June,
            year: 2020,
        },
    },
    {
        name: 'Unit Tests',
        date: {
            month: Months.November,
            year: 2020,
        },
        renderBelow: true,
    },
    {
        name: 'Performance Tests',
        date: {
            month: Months.September,
            year: 2021,
        },
    },
    {
        name: 'Snapshot Tests',
        date: {
            month: Months.February,
            year: 2023,
        },
        renderBelow: true,
    },
    {
        name: 'Tracker Integration',
        date: {
            month: Months.July,
            year: 2023,
        },
    },
];

const markers: EventDate[] = arrayRange(11).map(i => ({
    month: Months.January,
    year: 2013 + i,
}));

function computeTimestamp(eventDate: EventDate): number {
    const date = new Date();

    date.setDate(1);
    date.setMonth(eventDate.month);
    date.setFullYear(eventDate.year);
    date.setHours(0);
    date.setMinutes(0);
    date.setSeconds(0);

    return date.getTime();
}

const todayTimestamp = computeTimestamp(today);
const range = todayTimestamp - computeTimestamp(markers[0]);

function computeEvent(event: Event) {
    const timestamp = computeTimestamp(event.date);

    return {
        timestamp,
        name: event.name,
        delta: 1 - (todayTimestamp - timestamp) / range,
        renderBelow: !!event.renderBelow,
    };
}

function computeMarker(marker: EventDate) {
    const timestamp = computeTimestamp(marker);

    return {
        timestamp,
        name: marker.year,
        delta: 1 - (todayTimestamp - timestamp) / range,
    };
}

const revealed = ref(0);
const computedEvents = events.map(computeEvent);
const computedMarkers = markers.map(computeMarker);
</script>
