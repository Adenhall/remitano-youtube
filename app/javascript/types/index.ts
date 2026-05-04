export interface CurrentUser {
  id: number
  email: string
}

export interface Flash {
  notice?: string
  alert?: string
}

export interface SharedProps {
  currentUser: CurrentUser | null
  flash: Flash
}
