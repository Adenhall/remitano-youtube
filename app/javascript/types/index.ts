export interface CurrentUser {
  id: number
  email: string
}

export interface VideoItem {
  id: number
  youtube_id: string
  title: string
  shared_by: string
  shared_at: string
}

export interface Flash {
  notice?: string
  alert?: string
}

export interface SharedProps {
  currentUser: CurrentUser | null
  flash: Flash
  [key: string]: unknown
}
