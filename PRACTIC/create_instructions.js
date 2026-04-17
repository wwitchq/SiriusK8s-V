const PptxGenJS = require('pptxgenjs');

const prs = new PptxGenJS();
prs.defineLayout({ name: 'LAYOUT1', width: 10, height: 7.5 });
prs.defineLayout({ name: 'LAYOUT2', width: 10, height: 7.5 });

// Define colors
const colors = {
  darkBlue: '1F497D',
  lightBlue: 'D6E4F5',
  accent: 'F96167',
  darkGray: '424242',
  lightGray: 'F5F5F5',
  white: 'FFFFFF'
};

// Helper function to add slide with title
function addTitleSlide(prs, title, subtitle) {
  const slide = prs.addSlide();
  slide.background = { color: colors.darkBlue };
  
  slide.addText(title, {
    x: 0.5, y: 2.5, w: 9, h: 1.5,
    fontSize: 54, bold: true, color: colors.white,
    align: 'center', fontFace: 'Calibri'
  });
  
  if (subtitle) {
    slide.addText(subtitle, {
      x: 0.5, y: 4.2, w: 9, h: 1,
      fontSize: 28, color: colors.lightBlue,
      align: 'center', fontFace: 'Calibri'
    });
  }
  
  // Decorative bar
  slide.addShape(prs.ShapeType.rect, {
    x: 0, y: 6.8, w: 10, h: 0.7,
    fill: { color: colors.accent },
    line: { type: 'none' }
  });
}

function addContentSlide(prs, title, content) {
  const slide = prs.addSlide();
  slide.background = { color: colors.white };
  
  // Header background
  slide.addShape(prs.ShapeType.rect, {
    x: 0, y: 0, w: 10, h: 1.2,
    fill: { color: colors.darkBlue },
    line: { type: 'none' }
  });
  
  // Title
  slide.addText(title, {
    x: 0.5, y: 0.25, w: 9, h: 0.8,
    fontSize: 40, bold: true, color: colors.white,
    fontFace: 'Calibri', align: 'left'
  });
  
  // Content
  let y = 1.5;
  if (Array.isArray(content)) {
    content.forEach((item, idx) => {
      if (item.type === 'heading') {
        slide.addText(item.text, {
          x: 0.7, y: y, w: 8.6, h: 0.4,
          fontSize: 20, bold: true, color: colors.darkBlue,
          fontFace: 'Calibri'
        });
        y += 0.5;
      } else if (item.type === 'bullet') {
        slide.addText('• ' + item.text, {
          x: 1, y: y, w: 8.5, h: 0.35,
          fontSize: 14, color: colors.darkGray,
          fontFace: 'Calibri'
        });
        y += 0.45;
      } else if (item.type === 'code') {
        slide.addShape(prs.ShapeType.rect, {
          x: 0.7, y: y - 0.1, w: 8.6, h: item.height || 0.4,
          fill: { color: colors.lightGray },
          line: { color: colors.darkBlue, width: 1 }
        });
        slide.addText(item.text, {
          x: 0.9, y: y, w: 8.2, h: item.height || 0.3,
          fontSize: 11, color: colors.darkGray, fontFace: 'Courier New',
          valign: 'middle'
        });
        y += (item.height || 0.4) + 0.3;
      }
    });
  }
}

// Slide 1: Title
addTitleSlide(prs, 'SRE Практический Workshop', 'Инструкция по выполнению');

// Slide 2: Быстрый старт
addContentSlide(prs, '⚡ Быстрый старт (5 минут)', [
  { type: 'heading', text: 'Шаг 1: Подготовка' },
  { type: 'bullet', text: 'Перейдите в папку SiriusV2' },
  { type: 'code', text: 'cd SiriusV2', height: 0.35 },
  { type: 'bullet', text: 'Убедитесь, что Docker установлен' },
  { type: 'code', text: 'docker --version && docker-compose --version', height: 0.35 },
  { type: 'heading', text: 'Шаг 2: Запуск стека' },
  { type: 'bullet', text: 'Запустите все сервисы' },
  { type: 'code', text: 'docker-compose up --build', height: 0.35 },
  { type: 'bullet', text: 'Ждите сообщений "(healthy)" для всех сервисов' }
]);

// Slide 3: Структура проекта
addContentSlide(prs, '📁 Структура проекта', [
  { type: 'heading', text: 'Основные файлы' },
  { type: 'bullet', text: 'docker-compose.yml — оркестрация 4 сервисов' },
  { type: 'bullet', text: 'nginx.conf — конфигурация обратного прокси' },
  { type: 'bullet', text: 'middleware.js — rate limiting с логированием' },
  { type: 'bullet', text: 'main.go — HTTP сервер приложения' },
  { type: 'bullet', text: 'init-db.sql — инициализация базы данных' },
  { type: 'heading', text: 'Документация и тесты' },
  { type: 'bullet', text: 'README.md — полная документация (4000+ строк)' },
  { type: 'bullet', text: 'QUICK-REFERENCE.md — краткая шпаргалка' },
  { type: 'bullet', text: 'test-api.sh, test-rate-limiting.sh — тесты' }
]);

// Slide 4: Архитектура
addContentSlide(prs, '🏗️ Архитектура стека', [
  { type: 'heading', text: 'Слои приложения' },
  { type: 'bullet', text: 'Nginx (порт 80/443) → Reverse proxy, rate limiting' },
  { type: 'bullet', text: 'Rate Limiter (3000) → Token bucket алгоритм, логирование' },
  { type: 'bullet', text: 'Go App (8080) → /health, /api/status endpoints' },
  { type: 'bullet', text: 'PostgreSQL (5432) → Хранение данных и логов запросов' },
  { type: 'heading', text: 'Dual logging' },
  { type: 'bullet', text: 'Файлы: /app/logs/requests-YYYY-MM-DD.log (JSON)' },
  { type: 'bullet', text: 'База данных: таблица request_logs в PostgreSQL' }
]);

// Slide 5: Проверка работы
addContentSlide(prs, '✅ Проверка: Стек запущен', [
  { type: 'heading', text: 'Команда 1: Проверить статус сервисов' },
  { type: 'code', text: 'docker-compose ps', height: 0.35 },
  { type: 'bullet', text: 'Все 4 сервиса должны быть "Up" и "healthy"' },
  { type: 'heading', text: 'Команда 2: Проверить доступность' },
  { type: 'code', text: 'curl http://localhost/health', height: 0.35 },
  { type: 'bullet', text: 'Ожидается: HTTP 200 с JSON {"status":"healthy"}' },
  { type: 'heading', text: 'Команда 3: Проверить API' },
  { type: 'code', text: 'curl http://localhost/api/status', height: 0.35 },
  { type: 'bullet', text: 'Ожидается: HTTP 200 с данными о пользователях' }
]);

// Slide 6: Lesson 1 - Nginx
addContentSlide(prs, '📖 Lesson 1: Nginx (1.5 часа)', [
  { type: 'heading', text: 'Что изучаем:' },
  { type: 'bullet', text: '✓ Конфигурация обратного прокси' },
  { type: 'bullet', text: '✓ Rate limiting zones (api_limit, health_limit)' },
  { type: 'bullet', text: '✓ Логирование запросов' },
  { type: 'bullet', text: '✓ Upstream конфигурация' },
  { type: 'heading', text: 'Задачи:' },
  { type: 'bullet', text: '1. Откройте nginx.conf и изучите структуру' },
  { type: 'code', text: 'cat nginx.conf | head -50', height: 0.35 },
  { type: 'bullet', text: '2. Посмотрите логи nginx в реальном времени' },
  { type: 'code', text: 'docker-compose logs -f nginx', height: 0.35 }
]);

// Slide 7: Lesson 2 - Docker
addContentSlide(prs, '📖 Lesson 2: Docker (1.5 часа)', [
  { type: 'heading', text: 'Что изучаем:' },
  { type: 'bullet', text: '✓ Multi-stage builds' },
  { type: 'bullet', text: '✓ Оптимизация образов (Alpine)' },
  { type: 'bullet', text: '✓ Health checks' },
  { type: 'bullet', text: '✓ Volume management' },
  { type: 'heading', text: 'Команды:' },
  { type: 'bullet', text: 'Посмотреть слои образа:' },
  { type: 'code', text: 'docker history sirius_app', height: 0.35 },
  { type: 'bullet', text: 'Посмотреть размер образов:' },
  { type: 'code', text: 'docker images sirius_*', height: 0.35 }
]);

// Slide 8: Lesson 3 - Rate Limiting
addContentSlide(prs, '📖 Lesson 3: Rate Limiting (1.5 часа)', [
  { type: 'heading', text: 'Что изучаем:' },
  { type: 'bullet', text: '✓ Token bucket алгоритм' },
  { type: 'bullet', text: '✓ Per-IP rate limiting' },
  { type: 'bullet', text: '✓ HTTP 429 (Too Many Requests)' },
  { type: 'heading', text: 'Практика:' },
  { type: 'bullet', text: 'Запустите тест rate limiting' },
  { type: 'code', text: 'bash test-rate-limiting.sh', height: 0.35 },
  { type: 'bullet', text: 'Вы увидите:' },
  { type: 'bullet', text: '- Первые 20 запросов: 200 OK (burst)' },
  { type: 'bullet', text: '- Далее: 429 Too Many Requests' },
  { type: 'bullet', text: '- После паузы: снова 200 OK' }
]);

// Slide 9: Lesson 4 - Logging
addContentSlide(prs, '📖 Lesson 4: Logging & Observability (1.5 часа)', [
  { type: 'heading', text: 'Что изучаем:' },
  { type: 'bullet', text: '✓ Dual logging (файлы + база данных)' },
  { type: 'bullet', text: '✓ JSON структурированные логи' },
  { type: 'bullet', text: '✓ SQL анализ логов' },
  { type: 'heading', text: 'Команды для анализа:' },
  { type: 'bullet', text: 'Посмотреть JSON логи:' },
  { type: 'code', text: 'docker-compose exec rate-limiter cat /app/logs/requests-*.log | jq', height: 0.35 },
  { type: 'bullet', text: 'Запросить из БД:' },
  { type: 'code', text: 'docker-compose exec postgres psql -U demo -d demo -c "SELECT * FROM request_logs LIMIT 5;"', height: 0.45 }
]);

// Slide 10: Lesson 5 - Debugging
addContentSlide(prs, '📖 Lesson 5: Debugging & Security (1.5 часа)', [
  { type: 'heading', text: 'Что изучаем:' },
  { type: 'bullet', text: '✓ tcpdump — захват пакетов' },
  { type: 'bullet', text: '✓ curl — тестирование HTTP' },
  { type: 'bullet', text: '✓ strace — трассировка syscall' },
  { type: 'bullet', text: '✓ Docker security scanner' },
  { type: 'heading', text: 'Настройка инструментов:' },
  { type: 'code', text: 'bash setup-debugging.sh', height: 0.35 },
  { type: 'bullet', text: 'Загрузить помощники:' },
  { type: 'code', text: 'source debug-helpers.sh && debug_help', height: 0.35 }
]);

// Slide 11: Запуск тестов
addContentSlide(prs, '🧪 Запуск полного набора тестов', [
  { type: 'heading', text: 'Тест 1: API эндпоинты' },
  { type: 'code', text: 'bash test-api.sh', height: 0.35 },
  { type: 'bullet', text: 'Проверяет 17 сценариев (headers, timeouts, redirects...)' },
  { type: 'heading', text: 'Тест 2: Rate limiting' },
  { type: 'code', text: 'bash test-rate-limiting.sh', height: 0.35 },
  { type: 'bullet', text: 'Демонстрирует поведение token bucket' },
  { type: 'heading', text: 'Тест 3: Безопасность' },
  { type: 'code', text: './check-docker-security.sh app', height: 0.35 },
  { type: 'bullet', text: 'Проверяет 10 аспектов безопасности контейнера' }
]);

// Slide 12: Просмотр логов
addContentSlide(prs, '📊 Просмотр логов в реальном времени', [
  { type: 'heading', text: 'Логи middleware (rate limiter):' },
  { type: 'code', text: 'docker-compose logs -f rate-limiter', height: 0.35 },
  { type: 'heading', text: 'Логи приложения:' },
  { type: 'code', text: 'docker-compose logs -f app', height: 0.35 },
  { type: 'heading', text: 'Логи базы данных:' },
  { type: 'code', text: 'docker-compose logs -f postgres', height: 0.35 },
  { type: 'heading', text: 'Логи nginx:' },
  { type: 'code', text: 'docker-compose logs -f nginx', height: 0.35 },
  { type: 'bullet', text: 'Откройте несколько терминалов, чтобы следить за всеми' }
]);

// Slide 13: Сценарии отказа
addContentSlide(prs, '💥 Сценарии отказа для практики', [
  { type: 'heading', text: 'Сценарий 1: Повреждение БД' },
  { type: 'code', text: 'docker-compose exec postgres bash < break-db.sh', height: 0.35 },
  { type: 'bullet', text: 'Приложение получит ошибку БД → посмотрите логи' },
  { type: 'heading', text: 'Сценарий 2: Остановка сервиса' },
  { type: 'code', text: 'docker-compose stop app', height: 0.35 },
  { type: 'bullet', text: 'Запросы вернут 502 Bad Gateway' },
  { type: 'heading', text: 'Сценарий 3: Исчерпание rate limit' },
  { type: 'code', text: 'for i in {1..50}; do curl http://localhost/api/status; done', height: 0.35 },
  { type: 'bullet', text: 'Увидите: 200 OK, затем 429 Too Many Requests' }
]);

// Slide 14: Проверка завершения Lesson 1
addContentSlide(prs, '✅ Как проверить: Lesson 1 завершен', [
  { type: 'heading', text: 'Критерии успеха:' },
  { type: 'bullet', text: '☐ Вы можете объяснить структуру nginx.conf' },
  { type: 'bullet', text: '☐ Вы найдете определение rate limiting zones' },
  { type: 'bullet', text: '☐ Вы поняли upstream конфигурацию' },
  { type: 'bullet', text: '☐ Вы видите логи nginx в реальном времени' },
  { type: 'heading', text: 'Команда проверки:' },
  { type: 'code', text: 'grep -n "limit_req_zone" nginx.conf', height: 0.35 },
  { type: 'bullet', text: 'Должна показать 2 блока (api_limit и health_limit)' }
]);

// Slide 15: Проверка завершения Lesson 2
addContentSlide(prs, '✅ Как проверить: Lesson 2 завершен', [
  { type: 'heading', text: 'Критерии успеха:' },
  { type: 'bullet', text: '☐ Вы поняли multi-stage build в Dockerfile.app' },
  { type: 'bullet', text: '☐ Вы видите слои образа (builder → runtime)' },
  { type: 'bullet', text: '☐ Вы знаете, почему используется Alpine' },
  { type: 'bullet', text: '☐ Все сервисы запускаются и здоровы' },
  { type: 'heading', text: 'Команда проверки:' },
  { type: 'code', text: 'docker-compose ps', height: 0.35 },
  { type: 'bullet', text: 'Все 4 сервиса должны быть "Up (healthy)"' }
]);

// Slide 16: Проверка завершения Lesson 3
addContentSlide(prs, '✅ Как проверить: Lesson 3 завершен', [
  { type: 'heading', text: 'Критерии успеха:' },
  { type: 'bullet', text: '☐ Вы объяснили token bucket алгоритм' },
  { type: 'bullet', text: '☐ Вы видели первые 20 запросов с 200 OK' },
  { type: 'bullet', text: '☐ Вы видели 429 Too Many Requests' },
  { type: 'bullet', text: '☐ Вы знаете, что это per-IP rate limiting' },
  { type: 'heading', text: 'Команда проверки:' },
  { type: 'code', text: 'bash test-rate-limiting.sh 30', height: 0.35 },
  { type: 'bullet', text: 'Должна показать распределение 200 и 429 кодов' }
]);

// Slide 17: Проверка завершения Lesson 4
addContentSlide(prs, '✅ Как проверить: Lesson 4 завершен', [
  { type: 'heading', text: 'Критерии успеха:' },
  { type: 'bullet', text: '☐ Вы видели JSON логи в /app/logs/' },
  { type: 'bullet', text: '☐ Вы запросили данные из request_logs таблицы' },
  { type: 'bullet', text: '☐ Вы знаете связь между file logs и DB logs' },
  { type: 'bullet', text: '☐ Вы выполнили SQL запрос анализа' },
  { type: 'heading', text: 'Команда проверки:' },
  { type: 'code', text: 'docker-compose exec postgres psql -U demo -d demo -c "SELECT COUNT(*) FROM request_logs;"', height: 0.45 }
]);

// Slide 18: Проверка завершения Lesson 5
addContentSlide(prs, '✅ Как проверить: Lesson 5 завершен', [
  { type: 'heading', text: 'Критерии успеха:' },
  { type: 'bullet', text: '☐ Вы установили tcpdump, strace, curl' },
  { type: 'bullet', text: '☐ Вы видели пакеты через tcpdump' },
  { type: 'bullet', text: '☐ Вы трассировали syscalls через strace' },
  { type: 'bullet', text: '☐ Вы запустили security scanner' },
  { type: 'heading', text: 'Команды проверки:' },
  { type: 'code', text: 'bash setup-debugging.sh', height: 0.35 },
  { type: 'code', text: './check-docker-security.sh app', height: 0.35 }
]);

// Slide 19: Полезные команды отладки
addContentSlide(prs, '🔧 Полезные команды отладки', [
  { type: 'heading', text: 'Сетевая отладка:' },
  { type: 'code', text: 'docker-compose exec nginx tcpdump -i eth0 -A "tcp port 3000"', height: 0.4 },
  { type: 'heading', text: 'Трассировка syscalls:' },
  { type: 'code', text: 'docker-compose exec app strace -f -e trace=network ./app', height: 0.4 },
  { type: 'heading', text: 'Подключение к БД:' },
  { type: 'code', text: 'docker-compose exec postgres psql -U demo -d demo', height: 0.4 },
  { type: 'heading', text: 'Проверка сетевого подключения:' },
  { type: 'code', text: 'docker-compose exec app curl http://rate-limiter:3000/health', height: 0.4 }
]);

// Slide 20: Завершение
const finalSlide = prs.addSlide();
finalSlide.background = { color: colors.darkBlue };

finalSlide.addText('Готово к началу!', {
  x: 0.5, y: 2.5, w: 9, h: 1.5,
  fontSize: 54, bold: true, color: colors.white,
  align: 'center', fontFace: 'Calibri'
});

finalSlide.addText('Следуйте инструкциям для каждого Lesson\nПроверяйте критерии успеха\nЕсли возникли проблемы — смотрите README.md', {
  x: 0.5, y: 4, w: 9, h: 2,
  fontSize: 16, color: colors.lightBlue,
  align: 'center', fontFace: 'Calibri'
});

// Save
prs.save({ fileName: '/sessions/busy-eager-wright/mnt/Sirius/SRE_Workshop_Instructions_RU.pptx' });
console.log('✓ Создана инструкция: SRE_Workshop_Instructions_RU.pptx');
