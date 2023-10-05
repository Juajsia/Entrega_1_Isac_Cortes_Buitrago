window.onload = function () {
    // Variables
    const IMAGENES = [
        'Assets/12_01-Aportes-de-la-tecnologia-para-la-medicina-veterinaria.png',
        'Assets/Tercer-estilo-web-Tecnicos-Laborales_Auxiliar-veterinaria-3343669153.png',
        'Assets/20991-6867662acd00484485112e8a239d0ee5.png',
    ];
    const TIEMPO_INTERVALO_MILESIMAS_SEG = 8000;
    let posicionActual = 0;
    let $botonRetroceder = document.querySelector('#retroceder');
    let $botonAvanzar = document.querySelector('#avanzar');
    let $imagen = document.querySelector('#imagen');
    let intervalo;

    // Funciones

    /**
     * Funcion que cambia la foto en la siguiente posicion
     */
    function pasarFoto() {
        if (posicionActual >= IMAGENES.length - 1) {
            posicionActual = 0;
        } else {
            posicionActual++;
        }
        renderizarImagen();
    }

    /**
     * Funcion que cambia la foto en la anterior posicion
     */
    function retrocederFoto() {
        if (posicionActual <= 0) {
            posicionActual = IMAGENES.length - 1;
        } else {
            posicionActual--;
        }
        renderizarImagen();
    }

    /**
     * Funcion que actualiza la imagen de imagen dependiendo de posicionActual
     */
    function renderizarImagen() {
        $imagen.style.backgroundImage = `url(${IMAGENES[posicionActual]})`;
    }

    /**
     * Activa el autoplay de la imagen
     */
    function playIntervalo() {
        intervalo = setInterval(pasarFoto, TIEMPO_INTERVALO_MILESIMAS_SEG);
    }

    // Eventos
    function stopIntervalo() {
        clearInterval(intervalo);
        intervalo = null;
    }

    function pasarFotoManual() {
        stopIntervalo();
        pasarFoto();
        playIntervalo();
    }

    function retrocederFotoManual() {
        stopIntervalo();
        retrocederFoto();
        playIntervalo();
    }

    // Eventos
    $botonAvanzar.addEventListener('click', pasarFotoManual);
    $botonRetroceder.addEventListener('click', retrocederFotoManual);




    // Iniciar
    renderizarImagen();
    playIntervalo()
} 