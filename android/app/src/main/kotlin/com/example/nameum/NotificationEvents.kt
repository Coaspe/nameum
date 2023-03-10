package com.example.nameum

object NotificationEvents {
    const val RESERVE_ACCEPTED_NOTIFICATION_CLICKED = "RESERVE_ACCEPTED_NOTIFICATION_CLICKED"
    const val RESERVE_REJECTED_NOTIFICATION_CLICKED = "RESERVE_REJECTED_NOTIFICATION_CLICKED"
    const val RESERVE_COMPLETE_NOTIFICATION_CLICKED = "RESERVE_COMPLETE_NOTIFICATION_CLICKED"
    const val RESERVE_ACCEPTED = "reserve_accepted"
    val EVENT_TO_EVENT =  mapOf(RESERVE_ACCEPTED to RESERVE_ACCEPTED_NOTIFICATION_CLICKED)
}