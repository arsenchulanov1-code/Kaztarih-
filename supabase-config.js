// Ортақ рейтинг пен аккаунттар үшін Supabase баптауы.
// Бос тұрса, ойын тек осы құрылғыда жұмыс істейді.
// Supabase → Project Settings → API: Project URL және anon public key мәндерін қой.
// anon key құпия емес (қорғаныс — supabase.sql ішіндегі RLS ережелері).
window.SUPABASE_CONFIG = {
  url: "",
  anonKey: ""
};
