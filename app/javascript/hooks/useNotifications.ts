import { useEffect, useState } from "react"
import { createConsumer } from "@rails/actioncable"

interface Notification {
  title: string
  shared_by: string
}

export function useNotifications(currentUserEmail: string | null) {
  const [notification, setNotification] = useState<Notification | null>(null)

  useEffect(() => {
    if (!currentUserEmail) return

    const consumer = createConsumer()
    const subscription = consumer.subscriptions.create("NotificationsChannel", {
      received(data: Notification) {
        if (data.shared_by !== currentUserEmail) {
          setNotification(data)
        }
      }
    })

    return () => {
      subscription.unsubscribe()
      consumer.disconnect()
    }
  }, [currentUserEmail])

  return { notification, dismiss: () => setNotification(null) }
}
