<?php
require_once 'db.php';

$action = $_GET['action'] ?? $_POST['action'] ?? '';

// Parse JSON body if available
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, true) ?? $_POST;

if (empty($action) && isset($input['action'])) {
    $action = $input['action'];
}

switch ($action) {
    case 'register':
        $fullName = $input['full_name'] ?? '';
        $username = $input['email_or_student_id'] ?? '';
        $password = $input['password'] ?? '';

        if (empty($fullName) || empty($username) || empty($password)) {
            echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
            exit();
        }

        try {
            $stmt = $pdo->prepare("INSERT INTO users (full_name, email_or_student_id, password) VALUES (?, ?, ?)");
            $stmt->execute([$fullName, $username, $password]);
            echo json_encode([
                'status' => 'success',
                'message' => 'Registration successful',
                'user' => [
                    'full_name' => $fullName,
                    'email_or_student_id' => $username
                ]
            ]);
        } catch (PDOException $e) {
            if ($e->getCode() == 23000) {
                echo json_encode(['status' => 'error', 'message' => 'User already exists']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
            }
        }
        break;

    case 'login':
        $username = $input['email_or_student_id'] ?? '';
        $password = $input['password'] ?? '';

        $stmt = $pdo->prepare("SELECT * FROM users WHERE LOWER(email_or_student_id) = LOWER(?) AND password = ?");
        $stmt->execute([trim($username), $password]);
        $user = $stmt->fetch();

        if ($user) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Login successful',
                'user' => [
                    'id' => $user['id'],
                    'full_name' => $user['full_name'],
                    'email_or_student_id' => $user['email_or_student_id']
                ]
            ]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Invalid credentials or user not registered']);
        }
        break;

    case 'get_repairs':
        $stmt = $pdo->query("SELECT * FROM repairs ORDER BY id DESC");
        $repairs = $stmt->fetchAll();
        echo json_encode(['status' => 'success', 'data' => $repairs]);
        break;

    case 'add_repair':
        $ticketId = $input['ticket_id'] ?? '';
        $category = $input['category'] ?? '';
        $location = $input['location'] ?? '';
        $details = $input['details'] ?? '';
        $urgency = $input['urgency'] ?? 'ปกติ';
        $reporterName = $input['reporter_name'] ?? '';
        $dateFormatted = $input['date_formatted'] ?? '';

        if (empty($ticketId) || empty($category) || empty($location)) {
            echo json_encode(['status' => 'error', 'message' => 'Missing repair details']);
            exit();
        }

        try {
            $stmt = $pdo->prepare("INSERT INTO repairs (ticket_id, category, location, details, urgency, status, reporter_name, date_formatted) VALUES (?, ?, ?, ?, ?, 'pending', ?, ?)");
            $stmt->execute([$ticketId, $category, $location, $details, $urgency, $reporterName, $dateFormatted]);
            echo json_encode(['status' => 'success', 'message' => 'Repair created successfully']);
        } catch (PDOException $e) {
            echo json_encode(['status' => 'error', 'message' => 'Error saving repair: ' . $e->getMessage()]);
        }
        break;

    case 'update_repair_status':
        $ticketId = $input['ticket_id'] ?? '';
        $newStatus = $input['status'] ?? '';
        $techName = $input['technician_name'] ?? 'ช่างเทคนิค';

        if (empty($ticketId) || empty($newStatus)) {
            echo json_encode(['status' => 'error', 'message' => 'Missing ticket ID or status']);
            exit();
        }

        try {
            $stmt = $pdo->prepare("UPDATE repairs SET status = ?, technician_name = ? WHERE ticket_id = ?");
            $stmt->execute([$newStatus, $techName, $ticketId]);
            echo json_encode(['status' => 'success', 'message' => 'Repair status updated successfully']);
        } catch (PDOException $e) {
            echo json_encode(['status' => 'error', 'message' => 'Error updating status: ' . $e->getMessage()]);
        }
        break;

    case 'get_news':
        $stmt = $pdo->query("SELECT * FROM news ORDER BY id DESC");
        $news = $stmt->fetchAll();
        echo json_encode(['status' => 'success', 'data' => $news]);
        break;

    default:
        echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
        break;
}
?>
