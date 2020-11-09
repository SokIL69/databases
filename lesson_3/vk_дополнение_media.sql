--
-- ������ ��������� ����� ����� ���� ���� �������� ��������������� � ����� �������
--

-- ������� ��� ������ ������������� 
CREATE TABLE media_content_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  name VARCHAR(10) NOT NULL COMMENT "��� ����� ��������" -- id = 0/1 => name = "����"/"������"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "��� ����� ��������";

-- ������� �����
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������, ������� ������ �����������",
  media_type_id INT UNSIGNED NOT NULL COMMENT "������ �� ��� ��������",
  media_content_type_id int NOT NULL COMMENT "C����� �� ��� ������ �������������" -- media_content_type_id = 0/1 => media_content_type = "����"/"������"
  description VARCHAR(255) COMMENT "����������� ������������ � ������"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "�����";

-- ������� ����������� ����������� �������������
--
-- ������ ��������� ����� ����� ���� ���� �������� ��������������� � ����� �������
--
CREATE TABLE media_files (
  media_id INT UNSIGNED NOT NULL COMMENT "������ media-������ ��������� �������������",
  filename VARCHAR(255) NOT NULL COMMENT "���� � �����",
  -- extantion VARCHAR(4) NOT NULL COMMENT "���������� �����",
  size INT NOT NULL COMMENT "������ �����",
  file_data BLOB NOT NULL COMMENT "���������� �����",
  metadata JSON COMMENT "���������� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "����������";


-- ������� ������ �� ������������ � web
CREATE TABLE media_files (
  media_id INT UNSIGNED NOT NULL COMMENT "������ media-������ ��������� �������������",
  link VARCHAR(255) NOT NULL COMMENT "������ �� ����������� � web",
  metadata JSON COMMENT "���������� ������������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "�����������";

