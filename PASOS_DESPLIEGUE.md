# Guía paso a paso: publicar "Mi Equipo" en internet gratis

Con esto tendrás tu app accesible desde una URL propia, en cualquier
dispositivo, con login de usuario/contraseña, un administrador que
edita y usuarios que solo visualizan, y todo guardado en una base de
datos real (no en el navegador).

No necesitas programar nada más de lo que ya te he dejado hecho.
Solo tienes que seguir estos pasos con el ratón.

---

## Parte 1 · Crear la base de datos (Supabase) — 10 min

1. Ve a **https://supabase.com** → *Start your project* → crea una cuenta
   (puedes entrar con GitHub o Google).
2. Clica **New project**.
   - Ponle un nombre, ej. `mi-equipo`.
   - Elige una contraseña de base de datos (guárdala, no la necesitarás
     luego para nada del día a día, pero consérvala).
   - Elige una región cercana (ej. Europa).
   - Espera 1-2 minutos a que se cree el proyecto.
3. En el menú de la izquierda, entra en **SQL Editor** → **New query**.
4. Abre el archivo `schema.sql` que te he generado, copia **todo** su
   contenido, pégalo ahí, y pulsa **Run**.
   - Esto crea las tablas `profiles` (usuarios) y `team_data` (todos
     los datos del equipo), y las reglas de seguridad (solo el admin
     puede editar).
5. Ve a **Project Settings** (icono de engranaje) → **API**.
   - Copia el **Project URL** (algo como `https://xxxxx.supabase.co`).
   - Copia la clave **anon public** (una cadena larga).
   - Los necesitarás en la Parte 2.

### Crear tu usuario administrador

6. Ve a **Authentication** → **Users** → **Add user** → **Create new user**.
   - Pon tu email y una contraseña.
   - Marca la casilla "Auto Confirm User" si aparece (así no hace
     falta verificar el email).
7. Ve a **Table Editor** → tabla **profiles**.
   - Verás una fila con tu email y `role = viewer`.
   - Edita esa celda y cámbiala a `admin`. Guarda.
   - Ese usuario ya es tu administrador.

Para crear el resto de usuarios (los que solo podrán ver, por ejemplo
las familias o jugadoras) repites el paso 6 con cada email — se
crearán automáticamente como `viewer` (solo lectura), no hace falta
tocar nada más.

---

## Parte 2 · Configurar el archivo con tus datos de Supabase — 2 min

1. Abre el archivo `mi-equipo-web.html` con un editor de texto (por
   ejemplo el Bloc de notas, o mejor, VS Code).
2. Busca estas líneas (están casi al principio del `<script>`):

   ```js
   const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';
   const SUPABASE_ANON_KEY = 'TU-CLAVE-ANON-PUBLICA';
   ```

3. Sustituye los dos valores por el **Project URL** y la clave
   **anon public** que copiaste en el paso 5 de la Parte 1.
4. Guarda el archivo.

---

## Parte 3 · Publicar la web (Netlify) — 5 min

Uso Netlify porque permite subir el archivo arrastrándolo, sin usar
la terminal ni GitHub.

1. Ve a **https://app.netlify.com** → crea una cuenta gratis.
2. En el panel, busca la zona que dice algo como
   **"Drag and drop your site output folder here"** (arrastra aquí
   la carpeta de tu web) — normalmente en la pantalla de inicio o en
   *Sites*.
3. Antes de arrastrar, crea una carpeta en tu ordenador (ej.
   `mi-equipo-web`) y dentro **renombra** tu archivo a `index.html`
   exactamente (importante: debe llamarse así).
4. Arrastra esa carpeta entera a Netlify.
5. En unos segundos te dará una URL pública, tipo
   `https://nombre-al-azar.netlify.app`. ¡Ya está en internet!
6. (Opcional) En **Site settings → Change site name** puedes ponerle
   un nombre más bonito, tipo `mi-equipo-cf.netlify.app`.
7. (Opcional) En **Domain management** puedes conectar un dominio
   propio si compras uno (ej. `miequipo.com`).

Cada vez que quieras actualizar la web (por ejemplo si cambiamos
algo del diseño), solo tienes que volver a arrastrar la carpeta
actualizada a la misma web de Netlify.

---

## Cómo funciona el acceso a partir de ahora

- Cualquiera que entre en tu URL verá primero una pantalla de **login**
  (email + contraseña). Nadie puede registrarse por su cuenta: los
  usuarios los creas tú desde Supabase (Parte 1, paso 6).
- Tu usuario (marcado como `admin`) puede editar todo: jugadoras,
  convocatorias, alineaciones, lesiones, galería, escudo, nombre del
  equipo…
- El resto de usuarios (`viewer`) entran con su email/contraseña y
  ven exactamente los mismos datos, pero no pueden tocar nada — los
  botones de editar están desactivados, y aunque alguien intentara
  saltárselo con trucos técnicos, la base de datos también lo
  bloquea (política de seguridad a nivel de fila).
- Todos los datos se guardan en Supabase (no en el navegador), así
  que se ven igual desde el móvil, la tablet o el ordenador de
  cualquier usuario.

## Límites del plan gratuito (por si acaso)

- Supabase gratis: hasta 500 MB de base de datos y proyectos que se
  "pausan" tras 1 semana sin uso (se reactivan solos con un clic si
  eso pasa). De sobra para un equipo.
- Netlify gratis: 100 GB de tráfico al mes — más que suficiente.
- Si alguna vez subís muchísimas fotos de alta resolución podríais
  acercaros al límite de 500 MB; si pasa, te aviso y vemos cómo
  ampliarlo (los planes de pago son pocos euros al mes).

## Si algo no funciona

- Pantalla de login que no reacciona / error "Falta configurar
  Supabase": revisa que copiaste bien la URL y la clave `anon` en la
  Parte 2.
- "No se han podido cargar los datos": asegúrate de haber ejecutado
  el `schema.sql` completo en el SQL Editor de Supabase.
- Un usuario nuevo no ve nada / da error: comprueba en **Table Editor
  → profiles** que tiene una fila creada (se crea sola al añadir el
  usuario en Authentication → Users).
